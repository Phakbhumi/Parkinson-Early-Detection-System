import 'package:flutter/material.dart';

class FormView extends StatelessWidget {
  const FormView({
    super.key,
    required this.questionDetail,
    required this.onAnswer,
  });

  final String questionDetail;
  final ValueSetter<bool> onAnswer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 30.0,
              left: 30.0,
              right: 20.0,
            ),
            child: Text(
              questionDetail,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 100,
                    child: TextButton(
                      onPressed: () => onAnswer(true),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green.shade300,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                      ),
                      child: const Text(
                        "ใช่",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 100,
                  child: TextButton(
                    onPressed: () => onAnswer(false),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade300,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    child: const Text(
                      "ไม่ใช่",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
