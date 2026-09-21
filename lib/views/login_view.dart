import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exception.dart';
import 'package:mynotes/services/auth/auth_service.dart';
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
        future:AuthService.firebase().initialize(),
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
                   
                    await  AuthService.firebase().logIn(email: email, password: password);
                    final user = AuthService.firebase().currentUser;
                    if (user?.isEmailVerified??false) {
                       Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (_) => false);
                    }
                    else {
                       Navigator.of(context).pushNamedAndRemoveUntil(emailVerifyRoute, (_) => false);
                    }
                    if (!mounted) {
                      return;
                    }
                    
                  } on UserNotFoundAuthException{
                    await showErrorDialog(context, "User not found", "User is not registered");
                  } on WrongPasswordAuthException{
                    await showErrorDialog(context, "Wrong credentials", "Wrong password");
                  } on InvalidCredentialAuthException{
                   await showErrorDialog(
                        context,
                        "Login Failed",
                        "Invalid email or password.",
                      );
                  } on InvalidEmailAuthException{
                   await showErrorDialog(context, "Invalid email", "Invalid email");
                  } on UserDisabledAuthException{
                   await showErrorDialog(context, "User is disabled", "User is disabled");
                  } on GenericAuthException{
                    await showErrorDialog(context,
                    "Authentication Error",
                     "Authentication Error");
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
