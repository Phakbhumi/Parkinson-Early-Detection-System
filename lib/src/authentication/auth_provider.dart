import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // return error message (response)
  Future<String> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return 'กรุณากรอกอีเมลและรหัสผ่าน';
    }
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      return signInErrorClassify(e.toString());
    }
    return "";
  }

  //return error message (response)
  Future<String> signUp(String displayName, String email, String password, String passwordConfirmation) async {
    if (displayName.isEmpty || email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty) {
      return 'กรุณากรอกข้อมูลให้ครบถ้วน';
    }
    if (password != passwordConfirmation) {
      return 'รหัสผ่านไม่ตรงกัน';
    }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore.instance.collection('user-info').add(<String, dynamic>{
        'display-name': displayName,
        'email': email,
        'uid': FirebaseAuth.instance.currentUser!.uid,
      });
      return 'สร้างบัญชีใหม่สำเร็จ';
    } catch (e) {
      log(e.toString());
      return signUpErrorClassify(e.toString());
    }
  }

  String signInErrorClassify(String? eMessage) {
    switch (eMessage) {
      case "\"dev.flutter.pigeon.firebase_auth_platform_interface.FirebaseAuthHostApi.signInWithEmailAndPassword\".":
        return "กรุณากรอกอีเมลและรหัสผ่าน";
      case "[firebase_auth/invalid-email] The email address is badly formatted.":
        return "กรุณากรอกอีเมลให้ถูกต้อง";
      case "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.":
        return "อีเมลหรือรหัสผ่านไม่ถูกต้อง";
      default:
        return "เกิดข้อผิดพลาดในการเข้าสู่ระบบ";
    }
  }

  String signUpErrorClassify(String? eMessage) {
    switch (eMessage) {
      case "\"dev.flutter.pigeon.firebase_auth_platform_interface.FirebaseAuthHostApi.createUserWithEmailAndPassword\".":
        return "กรุณากรอกข้อมูลให้ครบถ้วน";
      case "[firebase_auth/invalid-email] The email address is badly formatted.":
        return "กรุณากรอกอีเมลให้ถูกต้อง";
      case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
        return "อีเมลนี้ได้ถูกใช้แล้ว";
      case "[firebase_auth/weak-password] Password should be at least 6 characters":
        return "รหัสผ่านควรมีอย่างน้อย 6 อักขระ";
      default:
        return "เกิดข้อผิดพลาดในการสร้างบัญชี";
    }
  }
}
