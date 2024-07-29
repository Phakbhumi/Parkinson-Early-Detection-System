import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkinson_detection/data/connect.dart';
import 'package:parkinson_detection/src/classifier.dart';
import 'spiral_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'display_spiral.dart';

class DisplayResultWidget extends StatefulWidget {
  const DisplayResultWidget({
    super.key,
    required this.capturedImageList,
    required this.onLoadingComplete,
  });

  final List<Uint8List> capturedImageList;
  final VoidCallback onLoadingComplete;
  @override
  State<DisplayResultWidget> createState() => _DisplayResultWidgetState();
}

class _DisplayResultWidgetState extends State<DisplayResultWidget> {
  List<SpiralData> results = [];
  bool isFetchingData = true;
  bool isFetchingSuccessful = false;
  bool confirmedConnection = false;
  bool isSpiral = true;
  List<bool> diagnosisData = [];
  int parkinsonCount = 0;

  void initVal() async {
    try {
      if (await Connectivity().hasInternetConnection() == false) {
        if (mounted) {
          Navigator.of(context).pop();
          await Connectivity().noInternetConfirmation(context);
        }
        return;
      }
      setState(() {
        confirmedConnection = true;
      });
      String spiralURL = 'https://seensiravit-demo-app.hf.space/predict/';
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.jpg').create();
      for (Uint8List image in widget.capturedImageList) {
        await file.writeAsBytes(image);
        var request = http.MultipartRequest('POST', Uri.parse(spiralURL))
          ..files.add(await http.MultipartFile.fromPath('file', '${tempDir.path}/image.jpg'));
        var response = await request.send().timeout(const Duration(seconds: 30));
        if (response.statusCode != 200) {
          log("HTTP error: ${response.statusCode}");
          if (mounted) {
            setState(() {
              isFetchingData = false;
            });
            widget.onLoadingComplete();
          }
          return;
        }
        final String resultString = await response.stream.bytesToString();
        if (mounted) {
          setState(() {
            results.insert(results.length, SpiralData.fromJson(jsonDecode(resultString)));
          });
        }
      }
      for (SpiralData result in results) {
        if (result.isSpiral == false) {
          isSpiral = false;
        }
        diagnosisData.insert(diagnosisData.length, result.isParkinson);
        if (result.isParkinson == true) {
          parkinsonCount++;
        }
      }
      if (isSpiral == true) {
        saveSpiralData();
      }
      if (mounted) {
        setState(() {
          isFetchingSuccessful = true;
          isFetchingData = false;
        });
      }
      widget.onLoadingComplete();
    } catch (_) {
      setState(() {
        isFetchingData = true;
      });
      widget.onLoadingComplete();
    }
  }

  @override
  void initState() {
    super.initState();
    initVal();
  }

  @override
  Widget build(BuildContext context) {
    if (isFetchingData == false) {
      if (isFetchingSuccessful == false) {
        return Text(
          "เกิดข้อผิดพลาดระหว่างการส่งข้อมูล",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      } else if (isSpiral == true) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ผลตรวจ: ${Classifier().verdictClassify(verdict())}",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Gap(10),
              Text(
                "จำนวนภาพที่มีความเสี่ยง: $parkinsonCount",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Gap(20),
              for (int index = 0; index < widget.capturedImageList.length; index++)
                ViewDrawing(
                  capturedImage: widget.capturedImageList[index],
                  isParkinson: diagnosisData[index],
                  index: index,
                ),
            ],
          ),
        );
      } else {
        return Text(
          "รูปที่คุณวาด อาจไม่ตรงกับภาพร่าง กรุณาวาดรูปใหม่",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        );
      }
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingAnimationWidget.threeArchedCircle(
            color: Theme.of(context).colorScheme.primary,
            size: 75,
          ),
          const Gap(20),
          Text(
            confirmedConnection ? "กำลังตรวจ: ${results.length + 1}/3" : "กำลังตรวจสอบสถานะอินเตอร์เน็ต",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      );
    }
  }

  void saveSpiralData() {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    if (widget.capturedImageList.length != 3) {
      return;
    }

    FirebaseFirestore.instance.collection('spiral-diagnosis-results').add(<String, dynamic>{
      'time': DateTime.now().toString(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'verdict': verdict(),
    });
  }

  String verdict() {
    if (parkinsonCount >= 2) {
      return 'severe';
    } else if (parkinsonCount == 1) {
      return 'medium';
    } else {
      return 'healthy';
    }
  }
}
