import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:parkinson_detection/src/check-up/motion/data_provider.dart';
import 'display_result.dart';
import 'package:go_router/go_router.dart';

class Dialogue {
  Future<void> diagnosisInstruction(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(
              "คำชี้แจง",
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(20),
                Text(
                  "จุดประสงค์ของเกมนี้ คือการพยายามควบคุมให้หยดน้ำ อยู่ตรงกลางหน้าให้ได้นานที่สุด",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Gap(10),
                Text(
                  "เมื่อท่านกดปุ่ม รับทราบ ระบบจะนับถอยหลัง 3 วินาที เพื่อให้ท่านปรับตำแหน่งให้ถนัดที่สุด โดยให้หันหน้าจอโทรศัพท์มือถือขึ้นด้านบน",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Gap(10),
                Text(
                  "เมื่อนับครบ 3 วินาที ขอให้ท่านพยายามควบคุมหยดน้ำให้นิ่งอยู่ตรงกลางให้ได้นานที่สุด จนกว่าจะมีข้อความแจ้งเตือน",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "รับทราบ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> diagnosisConfirmation(BuildContext context, List<VibrationData> collectedData) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(
              "ต้องการตรวจหรือไม่",
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/');
                      },
                      child: Text(
                        "ไม่ต้องการ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        sendData(collectedData);
                        Navigator.pop(context);
                        diagnosisResults(context, collectedData);
                      },
                      child: Text(
                        "ต้องการ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Future<void> diagnosisResults(BuildContext context, List<VibrationData> collectedData) {
    bool isLoading = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            titlePadding: const EdgeInsets.all(10),
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              "ผลการตรวจ",
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            content: DisplayResultWidget(
              collectedData: collectedData,
              onLoadingComplete: () {
                if (context.mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            ),
            actions: <Widget>[
              if (isLoading == false)
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: Text(
                    "รับทราบ",
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
    );
  }

  void sendData(List<VibrationData> collectedData) {
    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception('Must be logged in');
    }

    if (collectedData.isEmpty) {
      throw Exception('No data');
    }

    String parsedData = '[ ';
    for (VibrationData data in collectedData) {
      String temp = '[${data.x.toStringAsFixed(9)}, ${data.y.toStringAsFixed(9)}, ${data.z.toStringAsFixed(9)}],';
      parsedData += temp;
    }
    parsedData += ']';

    FirebaseFirestore.instance.collection('test-sensor-data').doc(DateTime.now().toString()).set(<String, dynamic>{
      'data': parsedData,
      'gmail': FirebaseAuth.instance.currentUser!.email,
    });
  }
}
