// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
        ),
        body: FutureBuilder(future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                  final user =FirebaseAuth.instance.currentUser;
                  
                  if (user?.emailVerified ?? false) {
                    print("Email is verified");
                  }
                  else{
                    print("first verified your email");
                  
                  }
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              return Center(child: Text("Loading..."));
            },
          ),
      );
  }


}


