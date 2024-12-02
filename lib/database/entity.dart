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
        'scored': scored,
      };

  factory Tag.fromMap(Map<String, Object?> map) {
    return Tag(
      id: map['tag_id'] as int?,
      name: map['name'] as String,
      color: map['color'] as int?,
      scored: map['scored'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Tag) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Tag(id: $id, name: $name, color: $color, scored: $scored)';
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

  factory Note.fromMap(Map<String, Object?> map) {
    return Note(
      id: map['note_id'] as int?,
      title: map['title'] as String?,
      body: map['body'] as String?,
      mediaUrls: map['media_urls'] as String?,
      createdAt: map['created_at'] as String,
      moodLevel: map['mood_level'] as int?,
      isPrivate: (map['is_private'] as int) == 1,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Note) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Note(id: $id, title: $title, body: $body, mediaUrls: $mediaUrls, createdAt: $createdAt, moodLevel: $moodLevel, isPrivate: $isPrivate)';
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

  factory Memory.fromMap(Map<String, Object?> map) {
    return Memory(
      id: map['memory_id'] as int?,
      name: map['name'] as String?,
      date: map['date'] as String?,
      time: map['time'] as String?,
      description: map['description'] as String?,
      createdAt: map['created_at'] as String,
      noteId: map['note_id'] as int?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Memory) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Memory(id: $id, name: $name, date: $date, time: $time, description: $description, createdAt: $createdAt, noteId: $noteId)';
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

  factory Notification.fromMap(Map<String, Object?> map) {
    return Notification(
      id: map['notification_id'] as int?,
      date: map['date'] as String,
      time: map['time'] as String,
      location: map['location'] as String,
      memoryId: map['memory_id'] as int?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Notification) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Notification(id: $id, date: $date, time: $time, location: $location, memoryId: $memoryId)';
}

class NoteTag {
  int noteId;
  int? tagId;

  NoteTag({
    required this.noteId,
    this.tagId,
  });

  Map<String, Object?> toMap() => {
        'note_id': noteId,
        'tag_id': tagId,
      };

  factory NoteTag.fromMap(Map<String, Object?> map) {
    return NoteTag(
      noteId: map['note_id'] as int,
      tagId: map['tag_id'] != null ? map['tag_id'] as int : null,
    );
  }

  @override
  String toString() => 'NoteTag(noteId: $noteId, tagId: $tagId)';
}

class Track {
  Track(
      {required this.id,
      required this.artist,
      required this.streamUrl,
      required this.thumbnailHeight,
      required this.thumbnailUrl,
      required this.thumbnailWidth,
      required this.title});

  String id;
  String streamUrl;
  String title;
  String thumbnailUrl;
  double thumbnailHeight;
  double thumbnailWidth;
  String artist;

  factory Track.fromMap(Map<String, dynamic> track) {
    return Track(
        id: track["id"]! as String,
        artist: track["artist"]! as String,
        streamUrl: track["streamUrl"]! as String,
        thumbnailHeight: (track["thumbnailHeight"] ?? 480).toDouble(),
        thumbnailUrl: track["thumbnailUrl"]! as String,
        thumbnailWidth: (track["thumbnailWidth"] ?? 360).toDouble(),
        title: track["title"]! as String);
  }
}
