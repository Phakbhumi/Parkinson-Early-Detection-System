import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'target.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:motion_sensors/motion_sensors.dart';
import 'package:parkinson_detection/src/check-up/motion/data_provider.dart';
import 'dialogue_options.dart';

class HandVibrationMeasure extends StatefulWidget {
  const HandVibrationMeasure({super.key});

  @override
  State<HandVibrationMeasure> createState() => _HandVibrationMeasureState();
}

class _HandVibrationMeasureState extends State<HandVibrationMeasure> {
  double roll = 0, pitch = 0, yaw = 0, startingYawValue = 0, previousYaw = 0;
  bool _isCalibrated = false;
  bool _isMonitoring = false;
  bool _onSplashScreen = false;
  int _splashScreenCountdown = 3;
  Timer? _splashScreenTimer;
  late StreamSubscription<AbsoluteOrientationEvent>? _absoluteOrientationSubscription;

  List<VibrationData> collectedData = [];

  void initSensor() {
    motionSensors.absoluteOrientationUpdateInterval = 10000;
    _absoluteOrientationSubscription = motionSensors.absoluteOrientation.listen((AbsoluteOrientationEvent event) {
      setState(() {
        previousYaw = yaw;
        roll = degrees(event.roll);
        pitch = degrees(event.pitch);
        yaw = degrees(event.yaw);
      });
      if (_onSplashScreen == true) {
        return;
      }
      if (_isCalibrated == false) {
        startingYawValue = yaw;
        _isCalibrated = true;
        _isMonitoring = true;
      } else if (_isMonitoring == true) {
        if (previousYaw < -150 && yaw > 150) {
          startingYawValue += 360;
        } else if (previousYaw > 150 && yaw < -150) {
          startingYawValue -= 360;
        }
        setState(() {
          collectedData.insert(
            collectedData.length,
            VibrationData(
              roll,
              pitch,
              yaw - startingYawValue,
            ),
          );
        });
        if (collectedData.length >= 1000) {
          _isMonitoring = false;
          if (mounted) {
            Dialogue().diagnosisConfirmation(context, collectedData);
          }
        }
      }
    });
  }

  void startSplashScreenCountdown() {
    _splashScreenTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_splashScreenCountdown == 1) {
        timer.cancel();
      } else {
        setState(() {
          _splashScreenCountdown--;
        });
      }
    });
  }

  void initWidget() async {
    if (mounted) {
      await Future.delayed(Duration.zero, () => Dialogue().diagnosisInstruction(context));
    }
    setState(() {
      _onSplashScreen = true;
    });
    startSplashScreenCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initSensor();
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _onSplashScreen = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initWidget();
  }

  @override
  void dispose() {
    super.dispose();
    _splashScreenTimer?.cancel();
    _absoluteOrientationSubscription?.cancel();
  }

  double displayWidth(double screenWidth) {
    double display = screenWidth * (0.5 + (roll / 30)) - 54;
    if (display < screenWidth * 0) {
      return screenWidth * 0;
    }
    if (display > screenWidth * 1.00 - 108) {
      return screenWidth * 1.00 - 108;
    }
    return display;
  }

  double displayHeight(double screenHeight) {
    double display = screenHeight * (0.5 + (pitch / 30)) - 63.5;
    if (display < screenHeight * 0) {
      return screenHeight * 0;
    }
    if (display > screenHeight * 1.00 - 127 - 60) {
      return screenHeight * 1.00 - 127 - 60;
    }
    return display;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          SafeArea(
            top: false,
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.waving_hand,
                      size: 35,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Gap(10),
                    Text(
                      "น้ำกลิ้งบนใบบอน",
                      style: TextStyle(
                        fontSize: 18,
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
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                centerTitle: true,
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/leaf_bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: (screenWidth * 0.5) - 98,
                    top: (screenHeight * 0.5) - 116,
                    child: const TargetView(),
                  ),
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "ผลการตรวจ: ${progressPercent()}%",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: displayWidth(screenWidth),
                    top: displayHeight(screenHeight),
                    child: Container(
                      height: 127,
                      width: 108,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/water_droplet.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_onSplashScreen)
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (_onSplashScreen)
            Center(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 3),
                tween: Tween<double>(
                  begin: 120,
                  end: 80,
                ),
                builder: (_, size, __) => DefaultTextStyle(
                  style: TextStyle(
                    fontSize: size,
                    color: Colors.white,
                  ),
                  child: Text("$_splashScreenCountdown"),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String progressPercent() {
    double dataPointsCollected = collectedData.length / 10;
    return dataPointsCollected.toStringAsFixed(2);
  }
}
