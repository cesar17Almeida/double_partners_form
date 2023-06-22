import 'package:flutter/material.dart';


class SeeAddressPopup extends StatelessWidget {
  const SeeAddressPopup({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Dirección"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(address)
        ],
      ),
    );
  }
}
