import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Acerca de mí"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/FOTO.png',
            height: 120,
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.drive_file_rename_outline),
            title: Text('Nombre'),
            subtitle: Text('Cesar Edwardo Almeida L.'),
          ),
          const ListTile(
            leading: Icon(Icons.book),
            title: Text('Universidad'),
            subtitle: Text('Santo Tomas'),
          ),
          const ListTile(
            leading: Icon(Icons.engineering),
            title: Text('Profesión'),
            subtitle: Text('Ingeniero de Telecomunicaciones'),
          ),
          const ListTile(
            leading: Icon(Icons.numbers),
            title: Text('Edad'),
            subtitle: Text('23 años'),
          )
        ],
      ),
    );
  }
}
