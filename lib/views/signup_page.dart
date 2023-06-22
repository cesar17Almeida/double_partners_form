import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:double_partners_form/utils/app_colors.dart';
import 'package:double_partners_form/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final dateController = TextEditingController();
  late TextEditingController countryController = TextEditingController();
  String _firstName = '';
  String _lastName = '';
  String _birthDate = '';
  String _country = '';
  String _city = '';
  String _address = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  late String userBirthDate;
  String datePickerValue = AppConstants.hintDate;
  final _signUpKey = GlobalKey<FormState>();
  DateTime dateTimestamp = DateTime.now();
  late DateTime nowDate =
      DateTime(dateTimestamp.year, dateTimestamp.month, dateTimestamp.day);
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Stack(
          children: <Widget>[
            Text(
              AppConstants.titleSignUp,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _signUpKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              maxLength: 60,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  value.toString().trim().length < 3
                                      ? 'Ingrese un nombre valido'
                                      : null,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-z-A-Z- ]"))
                              ],
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.person),
                                border: InputBorder.none,
                                counterText: '',
                                hintText: 'Nombre',
                                labelText: 'Nombre',
                              ),
                              onSaved: (val) => _firstName = val!,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              maxLength: 60,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  value.toString().trim().length < 3
                                      ? 'Ingrese un apellido valido'
                                      : null,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-z-A-Z- ]"))
                              ],
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.person),
                                  border: InputBorder.none,
                                  counterText: '',
                                  hintText: 'Apellido',
                                  labelText: 'Apellido'),
                              onSaved: (val) => _lastName = val!,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(FocusNode());
                      date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      // dateController.text = date!.toString();
                      datePickerValue = DateFormat('yyyy-MM-dd').format(date!);
                      dateController.text =
                          DateFormat('yyyy-MM-dd').format(date).toString();
                      nowDate = date;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese una fecha' : null,
                          controller: dateController,
                          decoration: const InputDecoration(
                              enabled: false,
                              icon: Icon(Icons.calendar_month),
                              border: InputBorder.none,
                              counterText: '',
                              hintText: 'Fecha de nacimiento',
                              labelText: 'Fecha de nacimiento',
                              errorStyle: TextStyle(color: Colors.redAccent)),
                          onSaved: (birthVal) =>
                              _birthDate = birthVal!.trim().toString(),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: false,
                              // optional. Shows phone code before the country name.
                              onSelect: (Country country) {
                                countryController.text =
                                    country.name.trim().toString();
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                controller: countryController,
                                enabled: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[A-z-0-9-#-]")
                                  )
                                ],
                                validator: (value) =>
                                    value!.isEmpty ? 'Ingrese su País' : null,
                                onSaved: (countryVal) => _country = countryVal!,
                                decoration: const InputDecoration(
                                    prefixIcon: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(Icons.flag)),
                                    border: InputBorder.none,
                                    counterText: '',
                                    hintText: 'País',
                                    labelText: 'País',
                                    errorStyle:
                                        TextStyle(color: Colors.redAccent)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              maxLength: 30,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[A-z-0-9-#-]")
                                )
                              ],
                              validator: (value) =>
                                  value!.length <= 2 ? 'Requerido' : null,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.location_city),
                                  border: InputBorder.none,
                                  counterText: '',
                                  hintText: 'Ciudad',
                                  labelText: 'Ciudad'),
                              onSaved: (val) => _city = val!,
                            ),
                          ),
                        ),
                      )
                    ],
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
                          FilteringTextInputFormatter.allow(
                              RegExp("[A-z-0-9-#-]")
                          )
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
                        onSaved: (val) => _address = val!,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            value != null && !authController.isValidEmail(value)
                                ? 'Ingrese un Email Válido '
                                : null,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-z-0-9-@-_.]"))
                        ],
                        maxLength: 80,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.email_rounded),
                            border: InputBorder.none,
                            counterText: '',
                            hintText: 'Email',
                            labelText: 'Email'),
                        onSaved: (val) => _email = val!,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        obscureText: true,
                        maxLength: 60,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          _password = value;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        validator: (value) => value != null && value.length < 6
                            ? 'Ingrese una contraseña válida'
                            : null,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.password),
                          border: InputBorder.none,
                          counterText: '',
                          hintText: 'Contraseña',
                          labelText: 'Contraseña',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null && value.length < 6) {
                            return 'Mínimo 6 caracteres';
                          } else if (value != _password) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                        obscureText: true,
                        maxLength: 60,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.password),
                          border: InputBorder.none,
                          counterText: '',
                          hintText: 'Confirmar Contraseña',
                          labelText: 'Confirmar Contraseña',
                        ),
                        onChanged: (value) {
                          _confirmPassword = value;
                        },
                        onSaved: (value) {
                          _confirmPassword = value!;
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_signUpKey.currentState!.validate()) {
                          _signUpKey.currentState!.save();
                          signUp();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Por favor revise el formulario')),
                          );
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(400.0, 50.0)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(AppColors.primary),
                      ),
                      child: const Text('Resgistrarse'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final List<dynamic> arrayAddress = [];
    arrayAddress.add(' {"country": "${_country.trim()}", "state": "${_city.trim()}",'
        ' "address": "${_address.trim()}" } ');
    try {
      showDialog(
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.trim(), password: _password.trim())
          .then(
        (value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(value.user!.uid)
              .set({
            'first_name': _firstName.trim(),
            'last_name': _lastName.trim(),
            'birth_date': _birthDate.trim(),
            'array_address': arrayAddress,
            'email': _email.trim(),
            'tutorial_done': false
          });
        },
      );
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppConstants.errorPasswordWeak)),
        );
      }
      if (e.code == 'email-already-in-use') {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppConstants.emailInUse)),
        );
      }
    }
  }
}
