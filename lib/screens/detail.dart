import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../evento.dart';

class EventDetailPage extends StatefulWidget {
  final Evento event;

  EventDetailPage({required this.event});
  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  // Marcar como required

  bool _isPlaying = false;

  AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playRecording() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
        });
      } else {
        Source urlSource = UrlSource(widget.event.audioPath);
        await _audioPlayer.play(urlSource);
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Error al reproducir la grabación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.titulo),
      ),
      body: ListView(
        children: <Widget>[
          widget.event.imagen != null
              ? Image.file(widget.event.imagen!)
              : SizedBox(),
          Text('Description: ${widget.event.descripcion}'),
          Text('Date: ${widget.event.fecha.toString()}'), // Mostrar la fecha
          if (widget.event.audioPath.isNotEmpty)
            ElevatedButton(
              onPressed: _playRecording,
              child:
                  _isPlaying ? Text('⏸️ Stop Audio') : Text('▶️ Start Audio'),
            ),
        ],
      ),
    );
  }
}
