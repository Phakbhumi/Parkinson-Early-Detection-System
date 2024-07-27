import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_displayNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('สร้างบัญชีใหม่สำเร็จ')),
        );
        FirebaseFirestore.instance.collection('user-info').add(<String, dynamic>{
          'display-name': _displayNameController.text,
          'email': _emailController.text,
          'uid': FirebaseAuth.instance.currentUser!.uid,
        });
        context.go('/');
      }
    } on FirebaseAuthException catch (e) {
      log("${e.message}");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorClassify(e.message))),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            "แอปพลิเคชั่นตรวจโรคพาร์กินสันขั้นพื้นฐาน",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/light_green_background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_information_outlined,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Gap(16),
                    Text(
                      "แอปพลิเคชั่นตรวจโรคพาร์กินสันขั้นพื้นฐาน",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Gap(32),
                    TextField(
                      controller: _displayNameController,
                      decoration: const InputDecoration(
                        labelText: 'ชื่อบัญชี',
                      ),
                    ),
                    const Gap(16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'อีเมล',
                      ),
                    ),
                    const Gap(16),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'รหัสผ่าน',
                      ),
                      obscureText: true,
                    ),
                    const Gap(16),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'ยืนยันรหัสผ่าน',
                      ),
                      obscureText: true,
                    ),
                    const Gap(16),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _signUp,
                            child: Text(
                              'สร้างบัญชี',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                    const Gap(16),
                    ElevatedButton(
                      onPressed: _isLoading ? () {} : () => context.go('/'),
                      child: Text(
                        'กลับไปหน้าเข้าสู่ระบบ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String errorClassify(String? eMessage) {
    switch (eMessage) {
      case "\"dev.flutter.pigeon.firebase_auth_platform_interface.FirebaseAuthHostApi.createUserWithEmailAndPassword\".":
        return "กรุณากรอกข้อมูลให้ครบถ้วน";
      case "The email address is badly formatted.":
        return "กรุณากรอกอีเมลให้ถูกต้อง";
      case "The email address is already in use by another account.":
        return "อีเมลนี้ได้ถูกใช้แล้ว";
      case "Password should be at least 6 characters":
        return "รหัสผ่านควรมีอย่างน้อย 6 อักขระ";
      default:
        return "เกิดข้อผิดพลาดในการสร้างบัญชี";
    }
  }
}
