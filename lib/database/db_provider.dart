import 'package:emodiary/database/db_service.dart';
import 'package:emodiary/database/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  // Delete all user data
  Future<void> deleteUserData() async {
    await dbService.deleteDb();
    await dbService.init();
    notifyListeners();
  }

  // create a new note
  Future<void> createNote({
    required Note note,
    required List<Tag> tags,
  }) async {
    note.id = await dbService.createNote(note);

    datesForStreaks.add(DateTime.parse(note.createdAt));

    if (tags.isEmpty) {
      await dbService.createNoteTag(NoteTag(noteId: note.id!));
    }

    for (Tag tag in tags) {
      await dbService.createNoteTag(NoteTag(noteId: note.id!, tagId: tag.id));
    }
    notifyListeners();
  }

  Future<void> updateNote({
    required Note note,
    required List<Tag> tags,
  }) async {
    await dbService.updateNote(note, note.id!);
    await dbService.deleteTagofNote(note.id!);
    if (tags.isEmpty) {
      await dbService.createNoteTag(NoteTag(noteId: note.id!));
    }

    for (Tag tag in tags) {
      await dbService.createNoteTag(NoteTag(noteId: note.id!, tagId: tag.id));
    }
    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    datesForStreaks.remove(DateTime.parse(note.createdAt));
    await dbService.deleteNote(note.id!);
    notifyListeners();
  }

  Future<List<DateTime>> getStreaksInMonth(DateTime date) async {
    final streaks = await dbService.getStreaksInMonth(date.toIso8601String().substring(0, 7));
    return streaks;
  }

}
