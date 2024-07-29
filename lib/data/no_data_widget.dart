import 'package:flutter/material.dart';
import 'package:parkinson_detection/src/components/missing_template.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MissingView(
      Icons.add_circle_outline,
      "ไม่มีข้อมูล กรุณาทำการตรวจเพื่อประมวลผล",
    );
  }
}
