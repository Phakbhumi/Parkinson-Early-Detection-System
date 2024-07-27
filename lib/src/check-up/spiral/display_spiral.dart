import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';

class ViewDrawing extends StatefulWidget {
  const ViewDrawing({
    super.key,
    required this.capturedImage,
    required this.isParkinson,
    required this.index,
  });

  final Uint8List capturedImage;
  final bool isParkinson;
  final int index;

  @override
  State<ViewDrawing> createState() => _ViewDrawingState();
}

class _ViewDrawingState extends State<ViewDrawing> {
  int downloadState = 3; // 0 - not download, 1 - start download, 2 - finish download, 3 - error

  Future<void> saveImage() async {
    if (downloadState != 0) return;
    try {
      setState(() {
        downloadState = 1;
      });
      final tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/spiral-${DateTime.now().toString()}.png';
      File file = await File(filePath).create();
      await file.writeAsBytes(widget.capturedImage);
      await Gal.putImage(filePath);
      setState(() {
        downloadState = 2;
      });
    } catch (_) {
      setState(() {
        downloadState = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.black,
            ),
          ),
          child: Image.memory(
            widget.capturedImage,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(5),
        Text(
          "ความเสี่ยงสำหรับภาพนี้: ${verdictClassify()}",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Gap(10),
        FilledButton(
          onPressed: saveImage,
          child: downloadStateDisplay(),
        ),
        if (widget.index != 2) const Gap(20),
      ],
    );
  }

  Widget downloadStateDisplay() {
    switch (downloadState) {
      case 0:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
            ),
            const Gap(8),
            Text(
              "ดาวน์โหลดรูป",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        );
      case 1:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const Gap(8),
            Text(
              "กำลังโหลดรูป",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        );
      case 2:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
            ),
            const Gap(8),
            Text(
              "ดาวน์โหลดเสร็จสิ้น",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        );
      default:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
            ),
            const Gap(8),
            Expanded(
              child: Text(
                "เกิดข้อผิิดพลาดบางอย่างขึ้น กรุณาลองใหม่อีกครั้ง",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
    }
  }

  String verdictClassify() {
    if (widget.isParkinson == true) {
      return "เสี่ยง";
    } else {
      return "ไม่เสี่ยง";
    }
  }
}
