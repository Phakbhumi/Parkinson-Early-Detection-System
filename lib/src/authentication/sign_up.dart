import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:parkinson_detection/src/authentication/auth_provider.dart';
import 'package:parkinson_detection/src/components/error_handler.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_isLoading == true) {
      ErrorHandler().showErrorDialogue(context, 'กรุณาอย่ากดรัวเกินไป');
    }
    setState(() {
      _isLoading = true;
    });
    String? response = await context.read<AuthDataProvider>().signUp(
          _displayNameController.text,
          _emailController.text,
          _passwordController.text,
          _confirmPasswordController.text,
        );
    setState(() {
      _isLoading = false;
    });
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
          automaticallyImplyLeading: false,
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
              child: SingleChildScrollView(
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
                      controller: _displayNameController,
                      decoration: const InputDecoration(
                        labelText: 'ชื่อบัญชี',
                      ),
                    ),
                    const Gap(16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'อีเมล',
                      ),
                    ),
                    const Gap(16),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'รหัสผ่าน',
                      ),
                      obscureText: true,
                    ),
                    const Gap(16),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'ยืนยันรหัสผ่าน',
                      ),
                      obscureText: true,
                    ),
                    const Gap(16),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _signUp,
                            child: Text(
                              'สร้างบัญชี',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                    const Gap(16),
                    ElevatedButton(
                      onPressed: _isLoading ? () {} : () => context.go('/'),
                      child: Text(
                        'กลับไปหน้าเข้าสู่ระบบ',
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
          ),
        ),
      ),
    );
  }
}
