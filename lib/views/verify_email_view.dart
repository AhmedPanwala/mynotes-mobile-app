import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:mynotes/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify email",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue),
      body: Column(
        children: [
          Text("Please Verify Your Email"),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: Text("Send Verification Email"),
          ),
          TextButton(onPressed: ()async{
           await FirebaseAuth.instance.signOut();
           Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (_)=>false);
          }, 
          child: Text("Restart")
          )
        ],
      ),
    );
  }
}
