import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MissingView extends StatelessWidget {
  const MissingView(this.icons, this.name, {super.key});
  final IconData icons;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icons,
            size: 65,
            color: Theme.of(context).colorScheme.primary,
          ),
          const Gap(10),
          Row(
            children: [
              const Gap(30),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(30),
            ],
          ),
        ],
      ),
    );
  }
}
