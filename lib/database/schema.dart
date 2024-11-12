final tables = [
  '''
  CREATE TABLE Tag (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    color INTEGER,
    scored INTEGER NOT NULL
  );
  ''',
  '''
  CREATE TABLE Note (
    id INTEGER PRIMARY KEY,
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
    id INTEGER PRIMARY KEY,
    name TEXT,
    date TEXT,
    time TEXT,
    description TEXT,
    created_at TEXT NOT NULL,
    note_id INTEGER,
    FOREIGN KEY(note_id) REFERENCES note(id)
  );
  ''',
  '''
  CREATE TABLE Notification (
    id INTEGER PRIMARY KEY,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    location TEXT NOT NULL,
    memory_id INTEGER,
    FOREIGN KEY(memory_id) REFERENCES memory(id)
  );
  ''',
  '''
  CREATE TABLE Note_tag (
    note_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY(note_id, tag_id),
    FOREIGN KEY(note_id) REFERENCES note(id),
    FOREIGN KEY(tag_id) REFERENCES tag(id)
  );
  '''];