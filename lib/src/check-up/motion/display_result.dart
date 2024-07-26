import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:parkinson_detection/data/connect.dart';
import 'package:parkinson_detection/src/check-up/motion/data_provider.dart';
import 'package:http/http.dart' as http;
import 'package:parkinson_detection/src/classifier.dart';
import 'package:path_provider/path_provider.dart';

class DisplayResultWidget extends StatefulWidget {
  const DisplayResultWidget({
    super.key,
    required this.collectedData,
    required this.onLoadingComplete,
  });

  final List<VibrationData> collectedData;
  final VoidCallback onLoadingComplete;

  @override
  State<DisplayResultWidget> createState() => _DisplayResultWidgetState();
}

class _DisplayResultWidgetState extends State<DisplayResultWidget> {
  bool isFetchingData = true;
  bool isFetchingSuccessful = false;
  String verdict = "";

  String parseAsString() {
    String parsedData = '[ ';
    for (VibrationData data in widget.collectedData) {
      String temp = '[${data.x.toStringAsFixed(9)}, ${data.y.toStringAsFixed(9)}, ${data.z.toStringAsFixed(9)}],';
      parsedData += temp;
    }
    parsedData += ']';
    return parsedData;
  }

  void initVal() async {
    try {
      if (await Connectivity().hasInternetConnection() == false) {
        if (mounted) {
          Navigator.of(context).pop();
          await Connectivity().noInternetConfirmation(context);
        }
        return;
      }
      String motionURL = 'https://seensiravit-demo-app.hf.space/predict_shake/';
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/data.txt').create();
      await file.writeAsBytes(parseAsString().codeUnits);
      var request = http.MultipartRequest('POST', Uri.parse(motionURL))
        ..files.add(await http.MultipartFile.fromPath('file', '${tempDir.path}/data.txt'));
      var response = await request.send().timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        if (mounted) {
          setState(() {
            isFetchingData = false;
          });
        }
        widget.onLoadingComplete();
        log("HTTP error: ${response.statusCode}");
        return;
      }
      verdict = processData(await response.stream.bytesToString());
      saveMotionData();
      if (mounted) {
        setState(() {
          isFetchingData = false;
          isFetchingSuccessful = true;
        });
      }
      widget.onLoadingComplete();
    } catch (_) {
      if (mounted) {
        setState(() {
          isFetchingData = false;
        });
      }
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
      return isFetchingSuccessful
          ? Text(
              "ผลตรวจ: ${Classifier().verdictClassify(verdict)}",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            )
          : Text(
              "เกิดข้อผิดพลาดระหว่างการส่งข้อมูล",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
            color: Theme.of(context).colorScheme.primary,
            size: 75,
          ),
        ],
      );
    }
  }

  String processData(String receivedVerdict) {
    if (receivedVerdict == '"low"') {
      return "healthy";
    } else if (receivedVerdict == '"mid"') {
      return "medium";
    } else if (receivedVerdict == '"high"') {
      return "severe";
    } else {
      return "invalid";
    }
  }

  void saveMotionData() {
    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception('Must be logged in');
    }

    FirebaseFirestore.instance.collection('motion-diagnosis-results').add(<String, dynamic>{
      'time': DateTime.now().toString(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'verdict': verdict,
    });
  }
}
