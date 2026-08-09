import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  String? _emailError;
  String? _passwordError;
  String? _loginError;

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
        title: Text("Login", style: TextStyle(color: Colors.white)),
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
                decoration: InputDecoration(
                  hintText: "Enter Your Email Here",
                  errorText: _emailError,
                ),
              ),
              if (_loginError != null)
                Text(_loginError!, style: const TextStyle(color: Colors.red)),
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  hintText: "Enter Your Password Here",
                  errorText: _passwordError,
                ),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _emailError = null;
                    _passwordError = null;
                    _loginError = null;
                  });
                  final email = _email.text.trim();
                  final password = _password.text;

                  if (email.isEmpty) {
                    setState(() {
                      _emailError = "Please enter your email";
                    });
                    return;
                  }
                  if (password.isEmpty) {
                    setState(() {
                      _passwordError = "Please enter your password";
                    });
                    return;
                  }
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    final user = FirebaseAuth.instance.currentUser;
                    if (user?.emailVerified??false) {
                       Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (_) => false);
                    }
                    else {
                       Navigator.of(context).pushNamedAndRemoveUntil(emailVerifyRoute, (_) => false);
                    }
                    if (!mounted) {
                      return;
                    }

                   
                   
                  } on FirebaseAuthException catch (e) {
                    devtools.log("Firebase error code: ${e.code}");
                    devtools.log("Firebase error message: ${e.message}");
                    if (e.code == "user-not-found") {
                      setState(() {
                        _emailError = "No account found with this email";
                      });
                    } else if (e.code == "wrong-password") {
                      setState(() {
                        _passwordError = "Please enter the correct password";
                      });
                    } else if (e.code == "invalid-credential") {
                      showErrorDialog(
                        context,
                        "Login Failed",
                        "Invalid email or password.",
                      );
                    } else if (e.code == "invalid-email") {
                      setState(() {
                        _emailError = "Please enter the valid email address";
                      });
                    } else if (e.code == "user-disabled") {
                      setState(() {
                        _loginError = "This account has been disabled.";
                      });
                    } else {
                      setState(() {
                        _loginError = "Something went wrong";
                      });
                    }
                    
                  }
                  catch(e){
                      await showErrorDialog(context, "Something went wrong", e.toString());
                  }
                },

                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: Text("Not register yet? Register here! "),
              ),
            ],
          );
        },
      ),
    );
  }
}
