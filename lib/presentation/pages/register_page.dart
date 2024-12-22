import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase/core/constants/colors.dart';
import 'package:flutter_chat_firebase/core/extensions/build_context_ext.dart';
import 'package:flutter_chat_firebase/presentation/pages/login_page.dart';

import '../../core/components/buttons.dart';
import '../../core/components/custom_text_field.dart';
import '../../core/components/spaces.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? confirmPasswordController;

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController?.dispose();
    emailController?.dispose();
    passwordController?.dispose();
    confirmPasswordController?.dispose();
    super.dispose();
  }

  void register() async {
    try {
      final authResult = await auth.createUserWithEmailAndPassword(
        email: emailController!.text,
        password: passwordController!.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'username': nameController!.text.trim().replaceAll(' ', ''),
        'email': emailController!.text,
        'name': nameController!.text,
      });
      context.pushReplacement(LoginPage());
      
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Failed'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(""),
        actions: const [],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SpaceHeight(32),
          const Center(
            child: Text(
              "Register dengan Email",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SpaceHeight(20),
          const Text(
            "Silahkan isi data diri anda",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: AppColors.grey),
          ),
          const SpaceHeight(32),
          CustomTextField(
            controller: nameController!,
            label: 'Nama',
            capizalize: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SpaceHeight(16),
          CustomTextField(
            controller: emailController!,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            capizalize: TextCapitalization.none,
            textInputAction: TextInputAction.next,
          ),
          const SpaceHeight(16),
          CustomTextField(
            controller: passwordController!,
            label: 'Password',
            obscureText: isPasswordObscure,
            textInputAction: TextInputAction.next,
            suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    isPasswordObscure = !isPasswordObscure;
                  });
                },
                child: Icon(isPasswordObscure
                    ? Icons.visibility_off
                    : Icons.visibility)),
          ),
          const SpaceHeight(16),
          CustomTextField(
            controller: confirmPasswordController!,
            label: 'Confirm Password',
            obscureText: isConfirmPasswordObscure,
            textInputAction: TextInputAction.done,
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  isConfirmPasswordObscure = !isConfirmPasswordObscure;
                });
              },
              child: Icon(
                isConfirmPasswordObscure
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),
          const SpaceHeight(32),
          SizedBox(
            width: context.deviceWidth,
            height: 52,
            child: Button.filled(
                onPressed: () {
                  register();
                },
                label: 'Buat Akun'),
          ),
        ],
      ),
    );
  }
}
