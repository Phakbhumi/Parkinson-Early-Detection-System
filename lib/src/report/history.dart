import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_detection/data/no_data_widget.dart';
import 'package:provider/provider.dart';
import 'package:parkinson_detection/data/results_provider.dart';
import 'package:parkinson_detection/src/classifier.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int sortBy = 0;

  @override
  void initState() {
    context.read<DiagnosisDataProvider>().initSort();
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
            "ประวัติการตรวจ",
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "จัดเรียงโดย",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Gap(10),
                    DropdownButton(
                      value: sortBy,
                      items: [
                        DropdownMenuItem(
                          value: 0,
                          child: Text(
                            "เวลาที่ตรวจ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text(
                            "ชนิดการตรวจ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        val == 0
                            ? context.read<DiagnosisDataProvider>().sortByDate()
                            : context.read<DiagnosisDataProvider>().sortByType();
                        setState(() {
                          sortBy = val!;
                        });
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.filter_list,
                          size: 21,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 20.0,
                      bottom: 20.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const HistoryView(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return context.read<DiagnosisDataProvider>().isEmpty()
        ? const NoDataWidget()
        : Consumer<DiagnosisDataProvider>(
            builder: (context, provider, _) => ListView.builder(
              itemCount: provider.diagnosisResult.length,
              itemBuilder: (context, index) => ShowResultsView(
                icons: Classifier().iconClassify(provider.diagnosisResult[index].type),
                typeName: Classifier().gameClassify(provider.diagnosisResult[index].type),
                severity: Classifier().verdictClassify(provider.diagnosisResult[index].verdict),
                dates: provider.diagnosisResult[index].time,
              ),
            ),
          );
  }
}

class ShowResultsView extends StatelessWidget {
  const ShowResultsView({
    super.key,
    required this.icons,
    required this.typeName,
    required this.severity,
    required this.dates,
  });

  final IconData icons;
  final String typeName;
  final String severity;
  final DateTime dates;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 5.0,
        bottom: 5.0,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                height: 80,
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
                    "เกม : $typeName",
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
                  Text(
                    "วันที่ตรวจ : ${DateFormat.yMd().format(dates)}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "เวลาที่ตรวจ : ${DateFormat.Hm().format(dates)}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
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
