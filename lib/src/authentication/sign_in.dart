import 'package:parkinson_detection/src/components/error_handler.dart';
import 'auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignInWithEmailPasswordLoad = false;
  bool _isSignInAsGuestLoad = false;

  Future<void> _signInWithEmailPassword() async {
    if (_isSignInWithEmailPasswordLoad == true || _isSignInAsGuestLoad == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาอย่ากดปุ่มรัวเกินไป')),
      );
    }
    setState(() {
      _isSignInWithEmailPasswordLoad = true;
    });
    String? response = await context.read<AuthDataProvider>().signInWithEmailPassword(
          _emailController.text,
          _passwordController.text,
        );
    setState(() {
      _isSignInWithEmailPasswordLoad = false;
    });
    if (mounted && response != null) {
      ErrorHandler().showErrorDialogue(context, response);
    }
    _isSignInWithEmailPasswordLoad = false;
  }

  Future<void> _signInAsGuest() async {
    if (_isSignInWithEmailPasswordLoad == true || _isSignInAsGuestLoad == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาอย่ากดปุ่มรัวเกินไป')),
      );
    }
    setState(() {
      _isSignInAsGuestLoad = true;
    });
    String? response = await context.read<AuthDataProvider>().signInAsGuest();
    if (mounted && response != null) {
      ErrorHandler().showErrorDialogue(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            "แอปพลิเคชั่นตรวจโรคพาร์กินสันขั้นพื้นฐาน",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/light_green_background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_information_outlined,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Gap(16),
                  Text(
                    "แอปพลิเคชั่นตรวจโรคพาร์กินสันขั้นพื้นฐาน",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Gap(32),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'อีเมล',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'รหัสผ่าน',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const Gap(16),
                  _isSignInWithEmailPasswordLoad
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _signInWithEmailPassword,
                          child: Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/sign-up');
                    },
                    child: Text(
                      'สร้างบัญชีใหม่',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _signInAsGuest,
                    icon: _isSignInAsGuestLoad ? const SizedBox() : const Icon(Icons.account_circle),
                    label: _isSignInAsGuestLoad
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            'เข้าสู่ระบบในฐานะแขก',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
