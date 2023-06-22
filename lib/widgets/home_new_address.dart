import 'package:country_picker/country_picker.dart';
import 'package:double_partners_form/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../utils/app_colors.dart';

class HomeNewAddress extends StatelessWidget {
  const HomeNewAddress({super.key});

  @override
  Widget build(BuildContext context) {
    late TextEditingController countryController = TextEditingController();
    String country = '';
    String address = '';
    String city = '';
    final newAddressKey = GlobalKey<FormState>();
    AuthController authController = Get.find<AuthController>();
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppConstants.newAddressTitle),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close))
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          key: newAddressKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    // optional. Shows phone code before the country name.
                    onSelect: (Country country) {
                      countryController.text = country.name.trim().toString();
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      controller: countryController,
                      enabled: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[A-z-0-9-#-]"))
                      ],
                      validator: (value) =>
                          value!.isEmpty ? 'Ingrese su País' : null,
                      onSaved: (countryVal) => country = countryVal!,
                      decoration: const InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.flag)),
                          border: InputBorder.none,
                          counterText: '',
                          hintText: 'País',
                          labelText: 'País',
                          errorStyle: TextStyle(color: Colors.redAccent)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: 30,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[A-z-0-9-#-]"))
                    ],
                    validator: (value) =>
                        value!.length <= 2 ? 'Requerido' : null,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.location_city),
                        border: InputBorder.none,
                        counterText: '',
                        hintText: 'Ciudad',
                        labelText: 'Ciudad'),
                    onSaved: (val) => city = val!,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: 35,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[A-z-0-9-#-]"))
                    ],
                    validator: (value) => value!.length <= 2
                        ? 'Ingresa una dirección válida'
                        : null,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.map_outlined),
                        border: InputBorder.none,
                        counterText: '',
                        hintText: 'Dirección',
                        labelText: 'Dirección'),
                    onSaved: (val) => address = val!,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (newAddressKey.currentState!.validate()) {
                      newAddressKey.currentState!.save();
                      // signUp();
                      if (await authController.createAddress(
                          country, address, city)) {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(AppConstants.errorGeneralIssue)),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppConstants.errorFormIssue)),
                      );
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(400.0, 50.0)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.primary),
                  ),
                  child: Text(AppConstants.newAddress))
            ],
          ),
        ),
      ),
    );
  }
}
