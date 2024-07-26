import 'dart:developer';
import 'sketch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'display_result.dart';

class Drawing extends StatefulWidget {
  const Drawing({super.key});

  @override
  State<Drawing> createState() => _DrawingState();
}

class _DrawingState extends State<Drawing> {
  List<Offset?> points = [];

  ScreenshotController screenshotController = ScreenshotController();
  List<Uint8List> capturedImageList = [];
  int pictureCount = 1;

  bool isOnSketchArea(Offset point) {
    if (point.dx < 1 || point.dx >= 299 || point.dy < 1 || point.dy >= 299) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var sketchAreaContainer = SketchArea(
      points: points,
      onDraw: (Offset point) {
        setState(() {
          if (isOnSketchArea(point) == false && points.isNotEmpty) {
            if (points[points.length - 1] != null) {
              points = List.from(points)..add(null);
            }
            return;
          }
          points = List.from(points)..add(point);
        });
      },
      onEndDraw: () {
        setState(() {
          points = List.from(points)..add(null);
        });
      },
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.draw,
                size: 45,
                color: Theme.of(context).colorScheme.primary,
              ),
              const Gap(10),
              Text(
                "เขียนเสือให้วัวกลัว",
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
          automaticallyImplyLeading: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/light_green_background.avif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "กรุณาวาดภาพตามภาพร่าง ภาพที่ $pictureCount/3",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Gap(30),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/spiral.png',
                        fit: BoxFit.cover,
                      ),
                      Screenshot(
                        controller: screenshotController,
                        child: sketchAreaContainer,
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                ElevatedButton(
                  onPressed: () {
                    screenshotController
                        .capture(delay: const Duration(milliseconds: 10))
                        .then((capturedImage) async {
                      capturedImageList.insert(
                          capturedImageList.length, capturedImage!);
                      if (pictureCount == 3) {
                        await showResult(capturedImageList);
                        capturedImageList.clear();
                        setState(() {
                          points = List.from(points)..clear();
                          pictureCount = 1;
                        });
                        return;
                      }
                      setState(() {
                        points = List.from(points)..clear();
                        pictureCount++;
                      });
                    }).catchError((onError) {
                      log(onError);
                    });
                  },
                  child: Text(
                    "ส่งภาพ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              points = List.from(points)..clear();
            });
          },
        ),
      ),
    );
  }

  Future<void> showResult(List<Uint8List> capturedImageList) async {
    bool isLoading = true;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => PopScope(
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
              capturedImageList: capturedImageList,
              onLoadingComplete: () => setState(() {
                isLoading = false;
              }),
            ),
            actions: <Widget>[
              if (isLoading == false)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/');
                  },
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
}
