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
      onCreate: (db, version) async {
        for (var table in tables) {
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

  Future<void> createNote(Note note) async {
    await _db!.insert(
      'Note',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getAllNotes() async {
    final allNotesMap = await _db!.query('Note');
    return [
      for (final {
        'id': id as int,
        'title': title as String?,
        'body': body as String?,
        'media_urls': mediaUrls as String?,
        'created_at': createdAt as String,
        'mood_level': moodLevel as int?,
        'is_private': isPrivate as int
      } in allNotesMap)
        Note(
          id: id,
          title: title,
          body: body,
          mediaUrls: mediaUrls,
          createdAt: createdAt,
          moodLevel: moodLevel,
          isPrivate: isPrivate == 1,
        ),
    ];
  }

  Future<List<Note>> getNotesByDate(String date) async {
    final notesMap = await _db!.query(
      'Note',
      where: "strftime('%Y-%m-%d', created_at) = ?",
      whereArgs: [date],
      orderBy: 'datetime(created_at) ASC',
    );

    return [
      for (final {
        'id': id as int,
        'title': title as String?,
        'body': body as String?,
        'media_urls': mediaUrls as String?,
        'created_at': createdAt as String,
        'mood_level': moodLevel as int?,
        'is_private': isPrivate as int
      } in notesMap)
        Note(
          id: id,
          title: title,
          body: body,
          mediaUrls: mediaUrls,
          createdAt: createdAt,
          moodLevel: moodLevel,
          isPrivate: isPrivate == 1,
        ),
    ];
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
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(int id) async {
    await _db!.delete(
      'Note',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Tag CRUD operations

  Future<void> createTag(Tag tag) async {
    await _db!.insert(
      'Tag',
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Tag>> getAllTags() async {
    final allTagsMap = await _db!.query('Tag');
    return [
      for (final {
        'id': id as int,
        'name': name as String,
        'color': color as int?,
        'scored': scored as int
      } in allTagsMap)
        Tag(id: id, name: name, color: color, scored: scored),
    ];
  }

  Future<void> updateTag(Tag tag, int id) async {
    await _db!.update(
      'Tag',
      tag.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTag(int id) async {
    await _db!.delete(
      'Tag',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Memory CRUD operations

  Future<void> createMemory(Memory memory) async {
    await _db!.insert(
      'Memory',
      memory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Memory>> getAllMemories() async {
    final allMemoriesMap = await _db!.query('Memory');
    return [
      for (final {
        'id': id as int,
        'name': name as String?,
        'date': date as String?,
        'time': time as String?,
        'description': description as String?,
        'created_at': createdAt as String,
        'note_id': noteId as int?
      } in allMemoriesMap)
        Memory(
          id: id,
          name: name,
          date: date,
          time: time,
          description: description,
          createdAt: createdAt,
          noteId: noteId,
        ),
    ];
  }

  Future<void> updateMemory(Memory memory, int id) async {
    await _db!.update(
      'Memory',
      memory.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMemory(int id) async {
    await _db!.delete(
      'Memory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Notification CRUD operations

  Future<void> createNotification(Notification notification) async {
    await _db!.insert(
      'Notification',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Notification>> getAllNotifications() async {
    final allNotificationsMap = await _db!.query('Notification');
    return [
      for (final {
        'id': id as int, 
        'date': date as String,
        'time': time as String,
        'location': location as String,
        'memory_id': memoryId as int?
      } in allNotificationsMap)
        Notification(
          id: id,
          date: date,
          time: time,
          location: location,
          memoryId: memoryId,
        ),
    ];
  }

  Future<void> updateNotification(Notification notification, int id) async {
    await _db!.update(
      'Notification',
      notification.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNotification(int id) async {
    await _db!.delete(
      'Notification',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // NoteTag operations (insert and delete only as it represents a relationship)

  Future<void> createNoteTag(NoteTag noteTag) async {
    await _db!.insert(
      'Note_tag',
      noteTag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteNoteTag(int noteId, int tagId) async {
    await _db!.delete(
      'Note_tag',
      where: 'note_id = ? AND tag_id = ?',
      whereArgs: [noteId, tagId],
    );
  }


}
