import 'package:emodiary/auth/user_state.dart';
import 'package:emodiary/database/db_service.dart';
import 'package:emodiary/database/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DbProvider extends ChangeNotifier {
  late User user;
  late DbService dbService;



  List<DateTime> datesForStreaks = <DateTime>[];
  Set<String> loadedMonth = {};

  // constructor
  DbProvider._({required this.user});

  static Future<DbProvider> create({required User user}) async {
    var dbProvider = DbProvider._(user: user);
    await dbProvider.init();

    return dbProvider;
  } 

  Future<void> init() async {
    dbService = await DbService.create(uid: user.uid);
    final streaks = await dbService.getStreaks();
    datesForStreaks.addAll(streaks);
  }

  Future<void> loadStreaks() async {
  }

  // Delete all user data
  Future<void> deleteUserData() async {
    await dbService.deleteDb();
    await dbService.init();
    notifyListeners();
  }

  // create a new note
  Future<void> createNote({
    required String title,
    required String body,
    String? mediaUrls,
    int? moodLevel,
    DateTime? createdAt,
    required bool isPrivate,
  }) async {
    createdAt ??= DateTime.now();
    await dbService.createNote(Note(
        title: title,
        body: body,
        mediaUrls: mediaUrls,
        moodLevel: moodLevel,
        createdAt: createdAt.toIso8601String(),
        isPrivate: isPrivate));
    datesForStreaks.add(createdAt);
    notifyListeners();
  }

  // get note by date
  Future<List<Note>> getNotesByDate(DateTime date) async {
    final notesInDate = await dbService.getNotesByDate(date.toIso8601String().substring(0, 10));
    return notesInDate;
  }

  Future<List<DateTime>> getStreaksInMonth(DateTime date) async {
    final streaks = await dbService.getStreaksInMonth(date.toIso8601String().substring(0, 7));
    return streaks;
  }

  // get all note
  Future<List<Note>> getAllNotes() async {
    final allNotes = await dbService.getAllNotes();
    return allNotes;
  }
}
