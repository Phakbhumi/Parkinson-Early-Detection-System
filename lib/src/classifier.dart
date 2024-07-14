import 'package:flutter/material.dart';

class Classifier {
  String gameClassify(String type) {
    if (type == "spiral") {
      return "เขียนเสือให้วัวกลัว";
    } else if (type == "form") {
      return "เล่าสู่กันฟัง";
    } else if (type == "motion") {
      return "น้ำกลิ้งบนใบบอน";
    } else {
      return "ไม่ทราบชนิด";
    }
  }

  String verdictClassify(String verdict) {
    if (verdict == "healthy") {
      return "ปกติ";
    } else if (verdict == "medium") {
      return "เสี่ยงน้อย";
    } else if (verdict == "severe") {
      return "เสี่ยงมาก";
    } else {
      return "ไม่มีข้อมูล";
    }
  }

  IconData iconClassify(String type) {
    if (type == "spiral") {
      return Icons.draw;
    } else if (type == "form") {
      return Icons.format_list_bulleted;
    } else if (type == "motion") {
      return Icons.waving_hand;
    } else {
      return Icons.check_box_outline_blank;
    }
  }
}
