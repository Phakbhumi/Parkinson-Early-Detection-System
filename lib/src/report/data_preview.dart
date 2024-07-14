import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:parkinson_detection/data/results_provider.dart';
import 'package:parkinson_detection/src/classifier.dart';
import 'package:provider/provider.dart';

class ShowAllData extends StatefulWidget {
  const ShowAllData({super.key});

  @override
  State<ShowAllData> createState() => _ShowAllDataState();
}

class _ShowAllDataState extends State<ShowAllData> {
  late String generalSeverity;
  late String spiralSeverity;
  late String formSeverity;
  late String motionSeverity;
  bool _isProcessingData = true;

  @override
  void initState() {
    setState(() {
      context.read<DiagnosisDataProvider>().calculateSeverity();
      generalSeverity = context.read<DiagnosisDataProvider>().generalSeverityLevel;
      spiralSeverity = context.read<DiagnosisDataProvider>().spiralSeverityLevel;
      formSeverity = context.read<DiagnosisDataProvider>().formSeverityLevel;
      motionSeverity = context.read<DiagnosisDataProvider>().motionSeverityLevel;
      _isProcessingData = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isProcessingData == true
        ? const CircularProgressIndicator()
        : Column(
            children: [
              const Gap(30),
              Text(
                "ผลการตรวจสอบทั้งหมด",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Gap(20),
              Text(
                "ความเสี่ยงโดยภาพรวม: ${Classifier().verdictClassify(generalSeverity)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Gap(10),
              ElevatedButton(
                onPressed: () {
                  context.go('/history');
                },
                child: Text(
                  "ประวัติการตรวจ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const Gap(20),
              SummarizeWidget(
                spiralSeverity: Classifier().verdictClassify(spiralSeverity),
                formSeverity: Classifier().verdictClassify(formSeverity),
                motionSeverity: Classifier().verdictClassify(motionSeverity),
              ),
              const Gap(20),
              ElevatedButton(
                onPressed: () async {
                  context.go('/guideline');
                },
                child: Text(
                  "ข้อควรปฎิบัติ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const Gap(10),
              ElevatedButton(
                onPressed: () {
                  context.go('/hospital-list');
                },
                child: Text(
                  "แนะนำโรงพยาบาล",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const Gap(20),
            ],
          );
  }
}

class SummarizeWidget extends StatelessWidget {
  const SummarizeWidget({
    super.key,
    required this.spiralSeverity,
    required this.formSeverity,
    required this.motionSeverity,
  });

  final String spiralSeverity;
  final String formSeverity;
  final String motionSeverity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummarizeGame(
          icons: Icons.waving_hand,
          type: Classifier().gameClassify("motion"),
          severity: motionSeverity,
        ),
        const Gap(5),
        SummarizeGame(
          icons: Icons.draw,
          type: Classifier().gameClassify("spiral"),
          severity: spiralSeverity,
        ),
        const Gap(5),
        SummarizeGame(
          icons: Icons.format_list_bulleted,
          type: Classifier().gameClassify("form"),
          severity: formSeverity,
        ),
      ],
    );
  }
}

class SummarizeGame extends StatelessWidget {
  const SummarizeGame({
    super.key,
    required this.icons,
    required this.type,
    required this.severity,
  });

  final IconData icons;
  final String type;
  final String severity;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Gap(10),
              SizedBox(
                width: 80,
                height: 70,
                child: Icon(
                  icons,
                  size: 55,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "เกม : $type",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "ความเสี่ยง : $severity",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }
}
