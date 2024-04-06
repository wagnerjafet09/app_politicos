import 'package:flutter/material.dart';
import 'package:app_politic/screens/about.dart';
import 'package:app_politic/screens/event_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '911 Team App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: EventListPage(),
      initialRoute: '/eventList',
      routes: {
        '/eventList': (context) => EventListPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void _onDrawerItemTap(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.purple.withOpacity(0.3),
      child: ListView(children: [
        SizedBox(
          height: 200,
          child: DrawerHeader(
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 80,
                  backgroundImage: AssetImage('assets/bandera.jpeg'),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.event,
            color: Colors.white,
          ),
          title: const Text(
            'Inicio',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () => {_onDrawerItemTap('/eventList')},
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          // color: Colors.red,
          child: ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            title: const Text(
              'Acerca De',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => {_onDrawerItemTap('/about')},
          ),
        ),
      ]),
    );
  }
}
