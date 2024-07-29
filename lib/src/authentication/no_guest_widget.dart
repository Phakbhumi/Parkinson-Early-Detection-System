import 'package:flutter/material.dart';
import 'package:parkinson_detection/src/components/missing_template.dart';

class NoGuestConfirmation extends StatelessWidget {
  const NoGuestConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return const MissingView(
      Icons.account_circle,
      "กรุณาเข้าสู่ระบบ เพื่อใช้งานฟีเจอร์นี้",
    );
  }
}
