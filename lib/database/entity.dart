class Tag {
  int? id;
  String name;
  int? color;
  int scored;

  Tag({
    this.id,
    required this.name,
    this.color,
    required this.scored,
  });

  Map<String, Object?> toMap() => {
        'name': name, 
        'color': color, 
        'scored': scored
      };

  @override
  String toString() => 'Tag(id: $id, name: $name, color: $color, scored: $scored)';
}

class Note {
  int? id;
  String? title;
  String? body;
  String? mediaUrls;
  String createdAt;
  int? moodLevel;
  bool isPrivate;

  Note({
    this.id,
    this.title,
    this.body,
    this.mediaUrls,
    required this.createdAt,
    this.moodLevel,
    required this.isPrivate,
  });

  Map<String, Object?> toMap() => {
        'title': title,
        'body': body,
        'media_urls': mediaUrls,
        'created_at': createdAt,
        'mood_level': moodLevel,
        'is_private': isPrivate ? 1 : 0,
      };
  
  @override
  String toString() => 'Note(id: $id, title: $title, body: $body, mediaUrls: $mediaUrls, createdAt: $createdAt, moodLevel: $moodLevel, isPrivate: $isPrivate)';
}

class Memory {
  int? id;
  String? name;
  String? date;
  String? time;
  String? description;
  String createdAt;
  int? noteId;

  Memory({
    this.id,
    this.name,
    this.date,
    this.time,
    this.description,
    required this.createdAt,
    this.noteId,
  });

  Map<String, Object?> toMap() => {
        'name': name,
        'date': date,
        'time': time,
        'description': description,
        'created_at': createdAt,
        'note_id': noteId,
      };

  @override
  String toString() => 'Memory(id: $id, name: $name, date: $date, time: $time, description: $description, createdAt: $createdAt, noteId: $noteId)';
}

class Notification {
  int? id;
  String date;
  String time;
  String location;
  int? memoryId;

  Notification({
    this.id,
    required this.date,
    required this.time,
    required this.location,
    this.memoryId,
  });

  Map<String, Object?> toMap() => {
        'date': date,
        'time': time,
        'location': location,
        'memory_id': memoryId,
      };

  @override
  String toString() => 'Notification(id: $id, date: $date, time: $time, location: $location, memoryId: $memoryId)';
}

class NoteTag {
  int noteId;
  int tagId;

  NoteTag({
    required this.noteId,
    required this.tagId,
  });

  Map<String, Object?> toMap() => {
        'note_id': noteId,
        'tag_id': tagId,
      };

  @override
  String toString() => 'NoteTag(noteId: $noteId, tagId: $tagId)';
}
