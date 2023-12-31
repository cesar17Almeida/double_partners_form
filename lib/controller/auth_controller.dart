import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth getUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth;
  }

  isValidEmail(String email) {
    bool match = RegExp(
            r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\])|(([a-zA-Z\-\d]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
    return match;
  }

  Future<bool> logIn(String email, String password) async {
    bool result = true;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      result = false;
    }
    return result;
  }

  Future<bool> createAddress(
      String country, String address, String city) async {
    bool result = true;
    String? uid = getUid().currentUser?.uid.toString();
    try {
      final CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('users');

      collectionRef.doc(uid).get().then(
        (documentSnapshot) {
          if (documentSnapshot.exists) {
            final dynamic data = documentSnapshot.data();
            if (data != null && data.containsKey('array_address')) {
              final List<dynamic>? array = data['array_address'];
              array?.add(' {"country": "$country", "state": "$city",'
                  ' "address": "$address" } ');
              collectionRef.doc(uid).update({'array_address': array});
            }
          }
        },
      );
    } catch (e) {
      result = false;
    }

    return result;
  }

  Stream<DocumentSnapshot> getAddressListener() {
    String? uid = getUid().currentUser?.uid.toString();
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);
    return documentReference.snapshots();
  }

  deleteAddress(int index) async {
    String? uid = getUid().currentUser?.uid.toString();

    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    // Map<String, dynamic> jsonData = json.decode(
    //     document['array_address'][index]);
    List addressArray = document['array_address'];
    addressArray.removeAt(index);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'array_address': addressArray});
  }
}
