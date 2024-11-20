import 'package:emodiary/database/db_provider.dart';
import 'package:emodiary/database/entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    DbProvider dbProvider = Provider.of<DbProvider>(context);
    return SafeArea(
      child: FutureBuilder<List<Map<String, Object?>>>(
        future: dbProvider.dbService.getNoteTag(), 
        builder:(context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                for (final notetag in snapshot.data!) 
                  Text(NoteTag.fromMap(notetag).toString()),
              ],
            );
          }
          return const Placeholder();
        },
      ),
    );
  }
}
