import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CheckUpView extends StatelessWidget {
  const CheckUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "การตรวจโรคพาร์กินสันขั้นพื้นฐาน",
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "โปรดเลือกหนึ่งในวิธีตังต่อไปนี้",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(12),
          CheckMethod(
            context,
            Icons.waving_hand,
            "น้ำกลิ้งบนใบบอน",
            "ควบคุมลูกบอล",
            '/motion',
          ),
          CheckMethod(
            context,
            Icons.draw,
            "เขียนเสือให้วัวกลัว",
            "วาดรูปตามภาพ",
            '/spiral',
          ),
          CheckMethod(
            context,
            Icons.format_list_bulleted,
            "เล่าสู่กันฟัง",
            "แบบสอบถาม",
            '/form',
          ),
        ],
      ),
    );
  }
}

class CheckMethod extends StatelessWidget {
  const CheckMethod(
    this.context,
    this.icons,
    this.name,
    this.desc,
    this.path, {
    super.key,
  });
  final BuildContext context;
  final IconData icons;
  final String name;
  final String desc;
  final String path;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 40.0,
        right: 40.0,
        top: 5.0,
        bottom: 5.0,
      ),
      child: InkWell(
        onTap: () => context.push(path),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(10),
                Icon(
                  icons,
                  size: 45,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(
                  width: 200,
                  height: 60,
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "($desc)",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
