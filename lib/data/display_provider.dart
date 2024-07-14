import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DisplaynameProvider extends ChangeNotifier {
  String displayName = "";

  void fetchDisplayName() async {
    final User? user = FirebaseAuth.instance.currentUser;

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("user-info").where('uid', isEqualTo: user!.uid).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      displayName = querySnapshot.docs.first['display-name'];
    } else {
      displayName = "ไม่ทราบ";
    }
    notifyListeners();
  }
}
