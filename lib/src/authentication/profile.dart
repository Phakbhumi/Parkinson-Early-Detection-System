import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:parkinson_detection/data/display_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "ข้อมูลส่วนตัว",
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ชื่อบัญชี: ${context.read<DisplaynameProvider>().displayName}",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Gap(10),
              Text(
                "อีเมล: ${FirebaseAuth.instance.currentUser!.email}",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const Gap(20),
          ElevatedButton(
            onPressed: () {
              context.go('/history');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.watch_later_outlined,
                  size: 27,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Gap(8),
                Text(
                  "ประวัติการตรวจ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          FilledButton(
            onPressed: () {
              signOutConfirmation();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout,
                  size: 30,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const Gap(8),
                Text(
                  "ออกจากระบบ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void signOutConfirmation() => showDialog(
        context: context,
        builder: (context) => PopScope(
          child: AlertDialog(
            title: Text(
              "ต้องการออกจากระบบหรือไม่",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "ไม่ต้องการ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "ต้องการ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
