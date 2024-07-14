import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Connectivity {
  Future<bool> hasInternetConnection() async {
    try {
      final response = await http.get(Uri.parse('https://www.example.com')).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  Future<void> noInternetConfirmation(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "กรุณาเชื่อมต่ออินเตอร์เน็ต",
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
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
      );
}
