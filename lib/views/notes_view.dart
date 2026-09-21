import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_actions.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes", style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<MenuOption>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              switch (value) {
                case MenuOption.logout:
                  final shouldLogout = await showLogOutputDialog(context);
                  if (shouldLogout) {
                    AuthService.firebase().signOut();
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuOption>(
                  value: MenuOption.logout,
                  child: Text("Log out"),
                ),
              ];
            },
          ),
        ],
        backgroundColor: Colors.lightBlue,
      ),
      body: Text("Notes"),
    );
  }
}