import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca De'),
        // backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/Foto.png', // URL de la foto del usuario
              ),
            ),
            title: Text('Wagner Jafet Matos Peña'),
            subtitle: Text('Programador mobile'),
          ),
          const Divider(), // Separador
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Correo electrónico'),
            subtitle: const Text('wagnerjafet09@gmail.com'),
            onTap: () {
              // Lógica para enviar correo electrónico
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Número de teléfono'),
            subtitle: const Text('+1-829-815-1891'),
            onTap: () {
              // Lógica para llamar al número de teléfono
            },
          ),
          const ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Ubicación'),
            subtitle: Text('Santo Domingo Norte'),
          ),
          const ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Matricula'),
            subtitle: Text('2022-0137'),
          ),
        ],
      ),
    );
  }
}
