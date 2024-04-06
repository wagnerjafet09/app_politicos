import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'dart:convert';
import '../evento.dart';

class EventFormPage extends StatefulWidget {
  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _date = DateTime.now(); // Nuevo campo de fecha
  late Record _audioRecord;
  late AudioPlayer _audioPlayer;
  bool _isRecording = false;
  String _audioPath = '';

  bool imageSeleccionada = false;

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

  void saveEvent(Evento event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> eventsJson = prefs.getStringList('events') ?? [];
    eventsJson.add(jsonEncode(event
        .toJson())); // Convierte el mapa a una cadena JSON antes de agregarlo
    prefs.setStringList('events', eventsJson);
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
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return 'Please enter a title';
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return 'Please enter a description';
                    }
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  _seleccionarImagen();
                  imageSeleccionada = true;
                },
                child: Text('Select Image'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _date = pickedDate; // Actualiza la fecha seleccionada
                    });
                  }
                },
                child: Text('Select Date'),
              ),
              if (_isRecording)
                Text(
                  '🎙️ Recording...',
                  style: TextStyle(fontSize: 18),
                ),
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                child: Text(
                    _isRecording ? '⏸️ Stop Recording' : '▶️ Start Recording'),
              ),
              if (imageSeleccionada)
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState!.validate()) {
                        Evento event = Evento(
                          titulo: _titleController.text,
                          descripcion: _descriptionController.text,
                          imagen: _image,
                          fecha: _date, // Asignar la fecha capturada
                          audioPath: _audioPath,
                        );
                        saveEvent(event);
                        // Devuelve el evento guardado a EventListPage
                        Navigator.pop(context, event);
                      }
                    }
                  },
                  child: Text('Save'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
