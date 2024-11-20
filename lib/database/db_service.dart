import 'package:emodiary/database/entity.dart';
import 'package:emodiary/database/schema.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  final String uid;
  Database? _db;

  DbService._({required this.uid});

  static Future<DbService> create({required String uid}) async {
    var dbService = DbService._(uid: uid);
    await dbService.init();
    return dbService;
  }

  Future<void> init() async {
    _db = await database;
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      join(await getDatabasesPath(), '$uid.db'),
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        for (var table in schema) {
          await db.execute(table);
        }
      },
    );
    return _db!;
  }

  // Delete database
  Future<void> deleteDb() async {
    _db!.close();
    await deleteDatabase(join(await getDatabasesPath(), '$uid.db'));
    _db = null;
  }

  // Note CRUD operations

  Future<int> createNote(Note note) async {
    int id = await _db!.insert(
      'Note',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Note>> getAllNotes() async {
    final allNotesMap = await _db!.query('Note');
    return [
      for (final note in allNotesMap)
        Note.fromMap(note),
    ];
  }

  Future<Map<Note, List<Tag>>> getNotesByDate(DateTime date) async {
    final dateString = "${date.toIso8601String().substring(0, 10)}%";
    final noteTagMap = await _db!.rawQuery(
      '''
      SELECT * 
      FROM Note_tag
      LEFT JOIN Note ON Note_tag.note_id = Note.note_id
      LEFT JOIN Tag ON Note_tag.tag_id = Tag.tag_id
      WHERE Note.created_at LIKE ?
      ''',
      [dateString]
    );
    Map<Note, List<Tag>> noteTags = {};
    for (final noteTag in noteTagMap) {
      final note = Note.fromMap(noteTag);
      noteTags[note] ??= <Tag>[]; 
      if (noteTag['tag_id'] != null) {
        noteTags[note]!.add(Tag.fromMap(noteTag));
      }
    }

    return noteTags;
  }

  Future<List<DateTime>> getStreaksInMonth(String yearMonth) async {
    final dateTimeString = await _db!.query(
      'Note',
      columns: ['created_at'],
      where: "strftime('%Y-%m', created_at) = ?",
      whereArgs: [yearMonth],
      orderBy: 'datetime(created_at) ASC',
    );

    return [
      for (final {'created_at': createdAt as String} in dateTimeString)
        DateTime.parse(createdAt),
    ];
  }

  Future<List<DateTime>> getStreaks() async {
    final dateTimeString = await _db!.query(
      'Note',
      columns: ['created_at'],
      // where: "strftime('%Y-%m', created_at) = ?",
      // whereArgs: [yearMonth],
      orderBy: 'datetime(created_at) ASC',
    );

    return [
      for (final {'created_at': createdAt as String} in dateTimeString)
        DateTime.parse(createdAt),
    ];
  }

  Future<void> updateNote(Note note, int id) async {
    await _db!.update(
      'Note',
      note.toMap(),
      where: 'note_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(int id) async {
    await _db!.delete(
      'Note',
      where: 'note_id = ?',
      whereArgs: [id],
    );
  }

  // Tag CRUD operations

  Future<int> createTag(Tag tag) async {
    int id = await _db!.insert(
      'Tag',
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Tag>> getAllTags() async {
    final allTagsMap = await _db!.query('Tag');
    return [
      for (final tag in allTagsMap)
        Tag.fromMap(tag),
    ];
  }
  Future<void> updateTag(Tag tag, int id) async {
    await _db!.update(
      'Tag',
      tag.toMap(),
      where: 'tag_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTag(int id) async {
    await _db!.delete(
      'Tag',
      where: 'tag_id = ?',
      whereArgs: [id],
    );
  }

  // Memory CRUD operations

  Future<int> createMemory(Memory memory) async {
    int id = await _db!.insert(
      'Memory',
      memory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Memory>> getAllMemories() async {
    final allMemoriesMap = await _db!.query('Memory');
    return [
      for (final memory in allMemoriesMap)
        Memory.fromMap(memory),
    ];
  }

  Future<void> updateMemory(Memory memory, int id) async {
    await _db!.update(
      'Memory',
      memory.toMap(),
      where: 'memory_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMemory(int id) async {
    await _db!.delete(
      'Memory',
      where: 'memory_id = ?',
      whereArgs: [id],
    );
  }

  // Notification CRUD operations

  Future<int> createNotification(Notification notification) async {
    int id = await _db!.insert(
      'Notification',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Notification>> getAllNotifications() async {
    final allNotificationsMap = await _db!.query('Notification');
    return [
      for (final notification in allNotificationsMap)
        Notification.fromMap(notification),
    ];
  }

  Future<void> updateNotification(Notification notification, int id) async {
    await _db!.update(
      'Notification',
      notification.toMap(),
      where: 'notification_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNotification(int id) async {
    await _db!.delete(
      'Notification',
      where: 'notification_id = ?',
      whereArgs: [id],
    );
  }

  // NoteTag operations (insert and delete only as it represents a relationship)

  Future<List<Map<String, Object?>>> getNoteTag() async {
    final allNoteTags = await _db!.query(
      'Note_tag',
    );

    return allNoteTags;
  }

  Future<int> createNoteTag(NoteTag noteTag) async {
    int id = await _db!.insert(
      'Note_tag',
      noteTag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteNoteTag(int noteId, int tagId) async {
    await _db!.delete(
      'Note_tag',
      where: 'note_id = ? AND tag_id = ?',
      whereArgs: [noteId, tagId],
    );
  }

  Future<void> deleteTagofNote(int noteId) async {
    await _db!.delete(
      'Note_tag',
      where: 'note_id = ?',
      whereArgs: [noteId],
    );
  }

}
