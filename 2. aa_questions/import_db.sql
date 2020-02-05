DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

-- turn on the foreign key constraints to ensure data integrity
PRAGMA foreign_keys = ON;

-- USERS

CREATE TABLE users
(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

INSERT INTO
  users (fname, lname)
VALUES
  ("Ned", "Ruggeri"), ("Kush", "Patel"), ("Earl", "Cat"),
  ("Pandu", "Panda");


--QUESTIONS

CREATE TABLE questions
(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
  questions (title, body, author_id)
SELECT
  "Ned Question", "Hello, I am Ned", 1
FROM 
  users
WHERE
  users.fname = "Ned" AND users.lname = "Ruggeri";

INSERT INTO
  questions (title, body, author_id)
SELECT
  "Kush Question", "Kush heree~", users.id
FROM
  users
WHERE
  users.fname = "Kush" AND users.lname = "Patel";

INSERT INTO
  questions (title, body, author_id)
SELECT
  "Earl Question", "MEOW MEOW MEOW", users.id
FROM
  users
WHERE
  users.fname = "Earl" AND users.lname = "Cat";

INSERT INTO
  questions (title, body, author_id)
SELECT
  "Panda Question", "Hello from Mars~", users.id
FROM
  users
WHERE
  users.fname = "Pandu" AND users.lname = "Panda";


-- QUESTION_FOLLOWS

CREATE TABLE question_follows
(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Ned" AND lname = "Ruggeri"),
  (SELECT id FROM questions WHERE title = "Earl Question")),

  ((SELECT id FROM users WHERE fname = "Kush" AND lname = "Patel"),
  (SELECT id FROM questions WHERE title = "Earl Question")
);


-- REPLIES

CREATE TABLE replies
(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  author_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
  replies (question_id, parent_reply_id, author_id, body)
VALUES
(
  (SELECT id FROM questions WHERE title = "Panda Question"),
  NULL,
  (SELECT id FROM users WHERE fname = "Ned" AND lname = "Ruggeri"),
  "Are you really from Mars?"
);

INSERT INTO
  replies (question_id, parent_reply_id, author_id, body)
VALUES
(
  (SELECT id FROM questions WHERE title = "Panda Question"),
  (SELECT id FROM replies WHERE question_id = 4),
  (SELECT id FROM users WHERE fname = "Kush" AND lname = "Patel"),
  "Hmm... Interesting. A fellow from Mars."
);


-- QUESTION_LIKES

CREATE TABLE question_likes
(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
(
  (SELECT id FROM users WHERE fname = "Kush" AND lname = "Patel"),
  (SELECT id FROM questions WHERE title = "Panda Question")
);