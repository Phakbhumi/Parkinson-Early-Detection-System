import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DiagnosisDataProvider extends ChangeNotifier {
  final List<DiagnosisResult> _diagnosisResult = [];
  List<DiagnosisResult> get diagnosisResult => _diagnosisResult;

  String generalSeverityLevel = "";
  String spiralSeverityLevel = "";
  String formSeverityLevel = "";
  String motionSeverityLevel = "";

  StreamSubscription<QuerySnapshot>? _getDiagnosisData;

  void fetchData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _diagnosisResult.clear();
      FirebaseFirestore.instance
          .collection("spiral-diagnosis-results")
          .where("uid", isEqualTo: user.uid)
          .where("verdict", whereIn: ["healthy", "medium", "severe"])
          .snapshots()
          .listen(
            (querySnapshot) {
              for (final document in querySnapshot.docs) {
                _diagnosisResult.add(DiagnosisResult(
                  time: DateTime.parse(document.data()['time']),
                  verdict: document.data()['verdict'] as String,
                  type: "spiral",
                ));
              }
            },
            onError: (e) => log("Error completing: $e"),
          );
      FirebaseFirestore.instance
          .collection("form-diagnosis-results")
          .where("uid", isEqualTo: user.uid)
          .where("verdict", whereIn: ["healthy", "medium", "severe"])
          .snapshots()
          .listen(
            (querySnapshot) {
              for (final document in querySnapshot.docs) {
                _diagnosisResult.add(DiagnosisResult(
                  time: DateTime.parse(document.data()['time']),
                  verdict: document.data()['verdict'] as String,
                  type: "form",
                ));
              }
            },
            onError: (e) => log("Error completing: $e"),
          );
      FirebaseFirestore.instance
          .collection("motion-diagnosis-results")
          .where("uid", isEqualTo: user.uid)
          .where("verdict", whereIn: ["healthy", "medium", "severe"])
          .snapshots()
          .listen(
            (querySnapshot) {
              for (final document in querySnapshot.docs) {
                _diagnosisResult.add(DiagnosisResult(
                  time: DateTime.parse(document.data()['time']),
                  verdict: document.data()['verdict'] as String,
                  type: "motion",
                ));
              }
            },
            onError: (e) => log("Error completing: $e"),
          );
    } else {
      _diagnosisResult.clear();
      _getDiagnosisData?.cancel();
      notifyListeners();
    }
  }

  void calculateSeverity() {
    generalSeverityLevel = "";
    spiralSeverityLevel = "";
    formSeverityLevel = "";
    motionSeverityLevel = "";

    DateTime latestSpiral = DateFormat("dd/MM/yyyy").parse("01/01/1970");
    DateTime latestForm = DateFormat("dd/MM/yyyy").parse("01/01/1970");
    DateTime latestMotion = DateFormat("dd/MM/yyyy").parse("01/01/1970");

    for (final result in _diagnosisResult) {
      if (result.type == "spiral" && result.time.compareTo(latestSpiral) > 0) {
        latestSpiral = result.time;
        spiralSeverityLevel = result.verdict;
      } else if (result.type == "form" && result.time.compareTo(latestForm) > 0) {
        latestForm = result.time;
        formSeverityLevel = result.verdict;
      } else if (result.type == "motion" && result.time.compareTo(latestMotion) > 0) {
        latestMotion = result.time;
        motionSeverityLevel = result.verdict;
      }
    }

    int sum = 0;
    int count = 0;

    if (spiralSeverityLevel != "") {
      sum += increase(spiralSeverityLevel);
      count++;
    }
    if (formSeverityLevel != "") {
      sum += increase(formSeverityLevel);
      count++;
    }
    if (motionSeverityLevel != "") {
      sum += increase(motionSeverityLevel);
      count++;
    }
    if (count != 0) {
      generalSeverityLevel = calSeverity(sum / count);
    }
  }

  void initSort() {
    _diagnosisResult.sort((a, b) => a.time.compareTo(b.time));
  }

  void sortByDate() {
    _diagnosisResult.sort((a, b) => a.time.compareTo(b.time));
    notifyListeners();
  }

  void sortByType() {
    _diagnosisResult.sort((a, b) => a.type.compareTo(b.type));
    notifyListeners();
  }

  bool isEmpty() {
    return _diagnosisResult.isEmpty;
  }

  String calSeverity(double value) {
    if (value < 1.60) {
      return "healthy";
    } else if (value < 2.40) {
      return "medium";
    } else {
      return "severe";
    }
  }

  int increase(String verdict) {
    if (verdict == "healthy") {
      return 1;
    } else if (verdict == "medium") {
      return 2;
    } else if (verdict == "severe") {
      return 3;
    } else {
      return 0;
    }
  }
}

class DiagnosisResult {
  DateTime time;
  String verdict;
  String type;
  DiagnosisResult({
    required this.time,
    required this.verdict,
    required this.type,
  });
}
