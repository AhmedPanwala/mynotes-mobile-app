import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';


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
                      await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        final user = FirebaseAuth.instance.currentUser;
                       await user?.sendEmailVerification();
                  Navigator.of(context).pushNamed(emailVerifyRoute);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "email-already-in-use") {
                     showErrorDialog(context, "Registration failed", 
                     "Email is already registered");
                    }
                    else if (e.code == "weak-password") {
                      showErrorDialog(context, "Registration failed", 
                     "Password is too weak");
                    }
                    else if (e.code == "invalid-email") {
                      showErrorDialog(context, "Registration failed", 
                     "Invalid Email address");
                    }
                  }
                  catch(e){
                    showErrorDialog(context, "Registration failed", 
                     e.toString());
                  }
                },
                child: Text("Register"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
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
