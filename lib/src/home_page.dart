import 'package:flutter/material.dart';
import 'package:parkinson_detection/data/results_provider.dart';
import 'package:parkinson_detection/data/display_provider.dart';
import 'package:provider/provider.dart';
import 'check-up/check_up.dart';
import 'report/data_preview.dart';
import 'authentication/profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late final TabController _tctrl;

  @override
  void initState() {
    _tctrl = TabController(
      length: 3,
      vsync: this,
    );
    context.read<DiagnosisDataProvider>().fetchData();
    context.read<DisplaynameProvider>().fetchDisplayName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "แอปพลิเคชั่นตรวจโรคพาร์กินสันขั้นพื้นฐาน",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/light_green_background.avif"),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: _tctrl,
            children: const [
              CheckUpView(),
              ShowAllData(),
              AccountView(),
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          controller: _tctrl,
          tabs: [
            Tab(
              icon: Icon(
                Icons.checklist,
                color: Theme.of(context).colorScheme.primary,
              ),
              text: "ตรวจโรค",
            ),
            Tab(
              icon: Icon(
                Icons.auto_graph,
                color: Theme.of(context).colorScheme.primary,
              ),
              text: "รายงานผล",
            ),
            Tab(
              icon: Icon(
                Icons.account_circle_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              text: "ข้อมูลส่วนตัว",
            ),
          ],
        ),
      ),
    );
  }
}
