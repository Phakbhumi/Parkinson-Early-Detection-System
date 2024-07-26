import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';

class ViewDrawing extends StatelessWidget {
  const ViewDrawing({
    super.key,
    required this.capturedImage,
    required this.isParkinson,
    required this.index,
  });

  final Uint8List capturedImage;
  final bool isParkinson;
  final int index;

  Future<void> saveImage() async {
    final tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/spiral-${DateTime.now().toString()}.png';
    File file = await File(filePath).create();
    await file.writeAsBytes(capturedImage);
    await Gal.putImage(filePath);
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
            capturedImage,
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
          child: Row(
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
          ),
        ),
        if (index != 2) const Gap(20),
      ],
    );
  }

  String verdictClassify() {
    if (isParkinson == true) {
      return "เสี่ยง";
    } else {
      return "ไม่เสี่ยง";
    }
  }
}
