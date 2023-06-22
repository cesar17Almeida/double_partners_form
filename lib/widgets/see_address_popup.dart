import 'package:double_partners_form/utils/app_constants.dart';
import 'package:flutter/material.dart';

class SeeAddressPopup extends StatelessWidget {
  const SeeAddressPopup({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppConstants.address),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [Text(address)],
      ),
    );
  }
}
