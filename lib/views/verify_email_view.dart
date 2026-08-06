import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Please Verify Your Email"),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            devtools.log(user.toString());
            await user?.sendEmailVerification();
          },
          child: Text("Send Verification Email"),
        ),
      ],
    );
  }
}
