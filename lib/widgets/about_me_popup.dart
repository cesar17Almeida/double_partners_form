import 'package:double_partners_form/utils/app_constants.dart';
import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppConstants.aboutMeTitle),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/FOTO.png',
            height: 120,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.drive_file_rename_outline),
            title: const Text('Nombre'),
            subtitle: Text(AppConstants.aboutMeName),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Universidad'),
            subtitle: Text(AppConstants.aboutMeUniversity),
          ),
          ListTile(
            leading: const Icon(Icons.engineering),
            title: const Text('Profesión'),
            subtitle: Text(AppConstants.aboutMeProfession),
          ),
          ListTile(
            leading: const Icon(Icons.numbers),
            title: const Text('Edad'),
            subtitle: Text(AppConstants.aboutMeAge),
          )
        ],
      ),
    );
  }
}
