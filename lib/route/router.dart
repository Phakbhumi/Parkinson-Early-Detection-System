import 'package:go_router/go_router.dart';
import 'package:parkinson_detection/src/authentication/sign_up.dart';
import 'package:parkinson_detection/src/report/guidance/player.dart';
import 'package:parkinson_detection/src/report/history.dart';
import 'package:parkinson_detection/src/authentication/auth_gate.dart';
import 'package:parkinson_detection/src/check-up/form/form.dart';
import 'package:parkinson_detection/src/check-up/motion/motion_sensor.dart';
import 'package:parkinson_detection/src/check-up/spiral/spiral.dart';
import 'package:parkinson_detection/src/report/guidance/guideline.dart';
import 'package:parkinson_detection/src/report/hospital/hospital.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
      routes: [
        GoRoute(
          path: 'motion',
          builder: (context, state) => const HandVibrationMeasure(),
        ),
        GoRoute(
          path: 'spiral',
          builder: (context, state) => const Drawing(),
        ),
        GoRoute(
          path: 'form',
          builder: (context, state) => const ParkinsonsForm(),
        ),
        GoRoute(
          path: 'guideline',
          builder: (context, state) => const GuideLineDisplay(),
          routes: [
            GoRoute(
              path: 'player',
              builder: (context, state) => const InfoPlayer(),
            ),
          ],
        ),
        GoRoute(
          path: 'history',
          builder: (context, state) => const HistoryPage(),
        ),
        GoRoute(
          path: 'hospital-list',
          builder: (context, state) => const HospitalInfoDisplay(),
        ),
        GoRoute(
          path: 'sign-up',
          builder: (context, state) => const SignUpPage(),
        ),
      ],
    ),
  ],
);
