import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Elecciones App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Evento> eventos = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  File? _image;
  late Record _audioRecord;
  late AudioPlayer _audioPlayer;
  bool _isRecording = false;
  String _audioPath = '';

  @override
  void initState() {
    _audioRecord = Record();
    _audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _audioRecord.dispose();
    super.dispose();
  }

  Future<void> _grabarEvento() async {
    final evento = Evento(
      titulo: _tituloController.text,
      descripcion: _descripcionController.text,
      fecha: DateTime.now(),
      imagen: _image,
      audioPath: _audioPath,
    );

    setState(() {
      eventos.add(evento);
    });

    _tituloController.clear();
    _descripcionController.clear();
    _image = null;
    _audioPath = '';
  }

  Future<void> _seleccionarImagen() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecord.hasPermission()) {
        await _audioRecord.start();
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      print('Error al iniciar la grabación: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecord.stop();
      setState(() {
        _isRecording = false;
        _audioPath = path!;
      });
    } catch (e) {
      print('Error al detener la grabación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Eventos'),
      ),
      body: ListView.builder(
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(eventos[index].titulo),
            subtitle: Text(eventos[index].descripcion),
            leading: eventos[index].imagen != null
                ? Image.file(eventos[index].imagen!)
                : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetalleEventoPage(evento: eventos[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Nuevo Evento'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _tituloController,
                        decoration: InputDecoration(labelText: 'Título'),
                      ),
                      TextField(
                        controller: _descripcionController,
                        decoration: InputDecoration(labelText: 'Descripción'),
                      ),
                      _image != null
                          ? Image.file(_image!)
                          : ElevatedButton(
                              onPressed: _seleccionarImagen,
                              child: Text('Seleccionar Imagen'),
                            ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_isRecording) {
                              _stopRecording();
                            } else {
                              _startRecording();
                            }
                          });
                        },
                        child: Text(_isRecording
                            ? 'Stop Recording'
                            : 'Start Recording'),
                      ),
                      ElevatedButton(
                        onPressed: _grabarEvento,
                        child: Text('Grabar Evento'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class DetalleEventoPage extends StatefulWidget {
  final Evento evento;

  DetalleEventoPage({required this.evento});

  @override
  State<DetalleEventoPage> createState() => _DetalleEventoPageState();
}

class _DetalleEventoPageState extends State<DetalleEventoPage> {
  AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playRecording() async {
    try {
      Source urlSource = UrlSource(widget.evento.audioPath);
      await _audioPlayer.play(urlSource);
    } catch (e) {
      print('Error al reproducir la grabación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.evento.titulo),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.evento.imagen != null
              ? Image.file(widget.evento.imagen!)
              : SizedBox(),
          Text('Descripción: ${widget.evento.descripcion}'),
          Text('Fecha: ${widget.evento.fecha.toString()}'),
          if (widget.evento.audioPath.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                _playRecording;
              },
              child: Text('Reproducir Audio'),
            ),
        ],
      ),
    );
  }
}

class Evento {
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final File? imagen;
  final String audioPath;

  Evento({
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.imagen,
    required this.audioPath,
  });
}
