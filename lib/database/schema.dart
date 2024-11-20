final schema = [
  '''
  CREATE TABLE Tag (
    tag_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    color INTEGER,
    scored INTEGER NOT NULL
  );
  ''',
  '''
  CREATE TABLE Note (
    note_id INTEGER PRIMARY KEY,
    title TEXT,
    body TEXT,
    media_urls TEXT,
    created_at TEXT NOT NULL,
    mood_level INTEGER,
    is_private INTEGER NOT NULL
  );
  ''',
  '''
  CREATE TABLE Memory (
    memory_id INTEGER PRIMARY KEY,
    name TEXT,
    date TEXT,
    time TEXT,
    description TEXT,
    created_at TEXT NOT NULL,
    note_id INTEGER,
    FOREIGN KEY(note_id) REFERENCES note(note_id) ON DELETE SET NULL
  );
  ''',
  '''
  CREATE TABLE Notification (
    notification_id INTEGER PRIMARY KEY,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    location TEXT NOT NULL,
    memory_id INTEGER,
    FOREIGN KEY(memory_id) REFERENCES memory(memory_id) ON DELETE CASCADE
  );
  ''',
  '''
  CREATE TABLE Note_tag (
    note_id INTEGER NOT NULL,
    tag_id INTEGER,
    PRIMARY KEY(note_id, tag_id),
    FOREIGN KEY(note_id) REFERENCES note(note_id) ON DELETE CASCADE,
    FOREIGN KEY(tag_id) REFERENCES tag(tag_id) ON DELETE SET NULL
  );
  '''];