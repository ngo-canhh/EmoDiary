import 'package:emodiary/database/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbProvider>(context);

    return Text('${dbProvider.user.displayName}');
  }
}
