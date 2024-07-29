import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:parkinson_detection/src/classifier.dart';
import 'questions.dart';
import 'form_view.dart';

class ParkinsonsForm extends StatefulWidget {
  const ParkinsonsForm({super.key});

  @override
  State<ParkinsonsForm> createState() => _ParkinsonsFormState();
}

class _ParkinsonsFormState extends State<ParkinsonsForm> {
  int questionNumber = 1;
  int yesCount = 0;
  List<String> formQuestions = FormQuestions().questions;

  void onAnswer(bool answer) async {
    if (answer == true) yesCount++;
    if (questionNumber < 20) {
      setState(() {
        questionNumber++;
      });
      return;
    }
    await diagnosisResults(verdict(yesCount));
    if (mounted) context.go("/");
  }

  @override
  void initState() {
    super.initState();
    questionNumber = 1;
    yesCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.format_list_bulleted,
                size: 45,
                color: Theme.of(context).colorScheme.primary,
              ),
              const Gap(10),
              Text(
                "เล่าสู่กันฟัง",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "กรุณาตอบคำถามทั้งหมด",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Gap(10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Gap(5),
                          Text(
                            "คำถามที่ $questionNumber/20",
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const Gap(15),
                          FormView(
                            questionDetail: formQuestions[questionNumber - 1],
                            onAnswer: onAnswer,
                          ),
                          const Gap(10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> diagnosisResults(String verdict) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: const EdgeInsets.all(20.0),
        actionsAlignment: MainAxisAlignment.center,
        title: Center(
          child: Text(
            "ผลการตรวจ",
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "ผลตรวจ: ${Classifier().verdictClassify(verdict)}",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(10),
            Text(
              "คะแนนการตรวจ (ยิ่งน้อย ยิ่งดี): $yesCount/20",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              sendData();
              Navigator.of(context).pop();
            },
            child: Text(
              'รับทราบ',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendData() {
    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception('Must be logged in');
    }

    FirebaseFirestore.instance.collection('form-diagnosis-results').add(<String, dynamic>{
      'time': DateTime.now().toString(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'verdict': verdict(yesCount),
    });
  }

  String verdict(int yesCount) {
    if (yesCount > 13) {
      return "severe";
    } else if (yesCount > 8) {
      return "medium";
    } else {
      return "healthy";
    }
  }
}
