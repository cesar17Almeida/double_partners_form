import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:double_partners_form/utils/app_colors.dart';
import 'package:double_partners_form/widgets/see_address_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../widgets/home_new_address.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const HomeNewAddress();
                    });
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(
                    const Size(400.0, 50.0)),
                backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.primary),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SizedBox(),
                  Text('Añadir Dirección', style: TextStyle(color: AppColors.white),),
                  Icon(Icons.add)
                ],
              )),
          Divider(),
          Text('Tus direcciones'),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<DocumentSnapshot>(
              stream: authController.getAddressListener(),
              builder: (context, snapshot) {
                if ( snapshot.connectionState == ConnectionState.waiting ) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                if (snapshot.connectionState ==
                    ConnectionState.none) {
                  return const Center(
                    child: Text('No hay conexión a internet'),
                  );
                }
                if ( snapshot.hasData ) {
                  DocumentSnapshot<Object?>? document = snapshot.data;
                  int addressSize = document!['array_address'].length;

                  return ListView.builder(
                    shrinkWrap: true,
                      itemCount: addressSize,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> jsonData = json.decode(
                            document['array_address'][index]);
                      return ListTile(
                        leading: Icon(Icons.abc),
                        title: Text(jsonData['country']),
                        subtitle: Text(jsonData['state']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  // Show popup with address
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SeeAddressPopup(
                                          address : jsonData['address'].toString()
                                        );
                                      });
                                },
                                child: const Icon(
                                  Icons.remove_red_eye,
                                  color: AppColors.primary,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  authController.deleteAddress(index);
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        )
                      );
                      });
                } else {
                  return const Center(
                    child: Text(
                        "Ha ocurrido un error, intenta más tarde"),
                  );
                }
              },
            ),
          ),




          Center(
            child: ElevatedButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
            }, child: const Text('Cerrar sesión')),
          ),
        ],
      ),
    );
  }
}
