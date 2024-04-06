import 'package:flutter/material.dart';
import 'package:app_politic/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../evento.dart';
import 'detail.dart';
import 'form.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<Evento> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  void loadEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> eventsJson = prefs.getStringList('events') ?? [];
    setState(() {
      events = eventsJson
          .map((eventJson) => Evento.fromJson(jsonDecode(eventJson)))
          .toList();
    });
  }

  void _deleteEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    setState(() {
      events.clear(); // También puedes limpiar la lista local si es necesario
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(events[index].titulo),
                  subtitle: Text(events[index].descripcion),
                  leading: events[index].imagen != null
                      ? Image.file(events[index].imagen!)
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EventDetailPage(event: events[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Botón al final de la lista
          ElevatedButton(
            onPressed: () {
              _deleteEvents();
            },
            child: Text('Eliminar todo'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigator.push devuelve el evento guardado desde EventFormPage
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventFormPage(),
            ),
          );
          // Si se recibió un evento, agréguelo a la lista de eventos
          if (result != null && result is Evento) {
            setState(() {
              events.add(result);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
