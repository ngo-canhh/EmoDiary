import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:emodiary/database/db_service.dart';
import 'package:emodiary/database/entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
    await getUserDirectory();
  }

  // Delete all user data
  Future<void> deleteUserData() async {
    await dbService.deleteDb();
    final userDirectory = await getUserDirectory();
    userDirectory.delete(recursive: true);
    await dbService.init();
    notifyListeners();
  }


  Future<bool> isSimulator() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.isPhysicalDevice == false; // false nghĩa là đang chạy trên Simulator
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.isPhysicalDevice == false; // false nghĩa là đang chạy trên Emulator
    }
    return false; // Nếu không phải iOS hay Android
  }

  Future<Directory> getUserDirectory() async {
    late final Directory directory;
    if (await isSimulator()) {
      directory = Directory('/Users/ngocanhh/Documents/Workspace/Hust/project1/emodiary/lib/assets/simulator_application_document');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final userPath = '${directory.path}/${user.uid}';
    var userDirectory = Directory(userPath);

    userDirectory = await userDirectory.create(recursive: true);
    return userDirectory;
  }  

  Future<Set<String>> saveImages(Set<String> toSaves) async {
    final Set<String> saved = {};
    if (toSaves.isNotEmpty) {
      final userDirectory = await getUserDirectory();
      final userPath = userDirectory.path;
      for (final image in toSaves) {
        final fileName = image.split('/').last;
        final newFilePath = '$userPath/$fileName';
        final File file = File(image);
        await file.copy(newFilePath);
        saved.add(newFilePath);
      }
    }
    return saved;
  }

  Future<void> delImages(Set<String> toDels) async {
    if (toDels.isNotEmpty) {
      for (final image in toDels) {
        final File file = File(image);
        try {
        if (await file.exists()) {
          await file.delete();
        }} catch (e) {
          print('$e');
        }
      }
    }
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

  Future<void> deleteTag(Tag tag) async {
    dbService.deleteTag(tag.id!);
    notifyListeners();
  }

  Future<List<DateTime>> getStreaksInMonth(DateTime date) async {
    final streaks = await dbService.getStreaksInMonth(date.toIso8601String().substring(0, 7));
    return streaks;
  }

}
