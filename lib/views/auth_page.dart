import 'package:double_partners_form/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/about_me_popup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _email = '';
  String _password = '';
  bool incorrectPass = false;
  bool _obscurePassword = true;
  AuthController authController = Get.find<AuthController>();
  final _loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_rounded,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                      key: _loginKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: AppColors.primary),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) => value != null &&
                                              !authController
                                                  .isValidEmail(value)
                                          ? 'Ingrese un Email Válido '
                                          : null,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-z-0-9-@-_.]"))
                                      ],
                                      maxLength: 80,
                                      onSaved: (value) {
                                        _email = value!;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.abc),
                                        border: InputBorder.none,
                                        counterText: '',
                                        hintText: 'Email',
                                        labelText: 'Email',
                                        errorStyle: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: AppColors.primary),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) =>
                                          value != null && value.length < 4
                                              ? 'Ingrese una contraseña válida'
                                              : null,
                                      obscureText: _obscurePassword,
                                      onSaved: (value) {
                                        _password = value!;
                                      },
                                      decoration: InputDecoration(
                                          icon: const Icon(Icons.security),
                                          border: InputBorder.none,
                                          counterText: '',
                                          hintText: 'Contraseña',
                                          labelText: 'Contraseña',
                                          suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _obscurePassword =
                                                      !_obscurePassword;
                                                });
                                              },
                                              child: _obscurePassword
                                                  ? const Icon(
                                                      Icons.visibility_off)
                                                  : const Icon(
                                                      Icons.visibility))),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: incorrectPass,
                                      child: const Text(
                                        'Usuario o contraseña incorrecta',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpPage()),
                                        );
                                      },
                                      child: const Text(
                                        'Registrate aquí',
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_loginKey.currentState!.validate()) {
                                      _loginKey.currentState?.save();
                                      if (await authController.logIn(
                                          _email.trim(), _password.trim())) {
                                        // Get.offAll(() => const HomePage());
                                      } else {
                                        setState(() {
                                          incorrectPass = true;
                                        });
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            const Size(400.0, 50.0)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            AppColors.primary),
                                  ),
                                  child: const Text(
                                    'Ingresar',
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  'Acerca de mi',
                                  style: TextStyle(color: AppColors.primary),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const AboutMe();
                                            });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: Colors.grey[200]),
                                        child: const Icon(Icons.person),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
