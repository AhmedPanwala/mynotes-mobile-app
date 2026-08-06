import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, asyncSnapshot) {
          return Column(
            children: [
              TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: "Enter Your Email Here"),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  hintText: "Enter Your Password Here",
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    final usercredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                    devtools.log(usercredential.toString());
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "email-already-in-use") {
                      devtools.log("Email is already in the use");
                    }
                    if (e.code == "weak-password") {
                      devtools.log("Password is too weak");
                    }
                    if (e.code == "invalid-email") {
                      devtools.log("Invalid email");
                    }
                    devtools.log(e.code);
                  }
                },
                child: Text("Register"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login/', (route) => false);
                },
                child: Text("Already Register? login here"),
              ),
            ],
          );
        },
      ),
    );
  }
}
