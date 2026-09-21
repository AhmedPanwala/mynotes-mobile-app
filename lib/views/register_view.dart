import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exception.dart';
import 'package:mynotes/services/auth/auth_service.dart';
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
        future: AuthService.firebase().initialize(),
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
                    
                      await AuthService.firebase().createUser(email: email, password: password);
                        AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(emailVerifyRoute);
                  } on EmailAlreadyInUseException{
                   await showErrorDialog(context, "Registration failed", 
                     "Email is already registered");
                  } on WeakPasswordAuthException{
                    await showErrorDialog(context, "Registration failed", 
                     "Password is too weak");
                  } on InvalidEmailAuthException {
                    await showErrorDialog(context, "Registration failed", 
                     "Invalid Email address");
                  } on GenericAuthException {
                    await showErrorDialog(context, "Registration failed", 
                     "Registration failed");
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
