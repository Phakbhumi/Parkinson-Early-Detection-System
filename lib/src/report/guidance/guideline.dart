import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:parkinson_detection/data/connect.dart';
import 'package:parkinson_detection/data/results_provider.dart';
import 'package:parkinson_detection/src/components/no_data.dart';
import 'package:parkinson_detection/src/classifier.dart';
import 'guidetext.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GuideLineDisplay extends StatefulWidget {
  const GuideLineDisplay({super.key});

  @override
  State<GuideLineDisplay> createState() => _GuideLineDisplayState();
}

class _GuideLineDisplayState extends State<GuideLineDisplay> {
  String severityLevel = "";

  @override
  void initState() {
    severityLevel = context.read<DiagnosisDataProvider>().generalSeverityLevel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "ข้อควรปฎิบัติ",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
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
            child: Column(
              children: [
                const Gap(20),
                Text(
                  "ความเสี่ยงโดยภาพรวม: ${Classifier().verdictClassify(severityLevel)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Gap(20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "คำแนะนำ: ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 20.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: classify(),
                        ),
                      ),
                    ),
                  ),
                ),
                if (context.read<DiagnosisDataProvider>().diagnosisResult.isNotEmpty && severityLevel != "healthy")
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(30),
                      Text(
                        "* ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        "หากเป็นไปได้ควรพบแพทย์",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () async {
                    if (await Connectivity().hasInternetConnection() == false) {
                      if (context.mounted) {
                        Connectivity().noInternetConfirmation(context);
                      }
                    } else {
                      if (context.mounted) {
                        context.go('/guideline/player');
                      }
                    }
                  },
                  child: Text(
                    "ข้อมูลเพิ่มเติม",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget classify() {
    if (severityLevel == "healthy") {
      return GuideLineText(content: Guidetext().healthyGuide);
    } else if (severityLevel == "medium") {
      return GuideLineText(content: Guidetext().mediumGuide);
    } else if (severityLevel == "severe") {
      return GuideLineText(content: Guidetext().severeGuide);
    } else {
      return const NoDataWidget();
    }
  }
}

class GuideLineText extends StatelessWidget {
  const GuideLineText({
    super.key,
    required this.content,
  });

  final List<Guidetopic> content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: content.length,
            itemBuilder: (context, index) => Align(
              alignment: Alignment.topLeft,
              child: ListItem(content[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem(this.content, {super.key});
  final Guidetopic content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content.topic,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Gap(5),
        for (final guide in content.content)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "-  ",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  guide,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        const Gap(10),
      ],
    );
  }
}
