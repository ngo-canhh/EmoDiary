import 'package:emodiary/components/auth_textfield.dart';
import 'package:emodiary/database/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotePage extends StatelessWidget {
  late final DateTime? date;

  NotePage({super.key, this.date});

  final titleController = TextEditingController();

  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DbProvider dbProvider = Provider.of<DbProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          AuthTextfield(
              hintText: 'Title',
              obscureText: false,
              controller: titleController),
          AuthTextfield(
              hintText: 'What are you thinking',
              obscureText: false,
              controller: bodyController),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await dbProvider.createNote(
            title: titleController.text,
            body: bodyController.text,
            createdAt: date,
            isPrivate: false);
        Navigator.pop(context);
      },
      child: Icon(Icons.add),),
    );
  }
}
