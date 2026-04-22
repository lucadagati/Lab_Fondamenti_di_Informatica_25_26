-- Lab 07 — schema didattico (SQLite)
-- Uso da terminale: sqlite3 ../dati/lab07_biomed.db < lab07_schema.sql
-- (eseguire dalla cartella sql/ oppure adattare i path)

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS esami_lab;
DROP TABLE IF EXISTS pazienti;

CREATE TABLE pazienti (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    nome          TEXT NOT NULL,
    cognome       TEXT NOT NULL,
    anno_nascita  INTEGER,
    sesso         TEXT CHECK (sesso IN ('M', 'F', 'X')) DEFAULT 'X'
);

CREATE TABLE esami_lab (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    paziente_id   INTEGER NOT NULL REFERENCES pazienti(id) ON DELETE CASCADE,
    nome_esame    TEXT NOT NULL,
    valore        REAL NOT NULL,
    unita         TEXT NOT NULL,
    data_esame    TEXT NOT NULL,
    note          TEXT
);

INSERT INTO pazienti (nome, cognome, anno_nascita, sesso) VALUES
    ('Giulia', 'Verdi', 1992, 'F'),
    ('Marco', 'Bianchi', 1985, 'M'),
    ('Laura', 'Neri', 2001, 'F');

INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame, note) VALUES
    (1, 'Glicemia', 92.0, 'mg/dL', '2025-01-10', NULL),
    (1, 'Glicemia', 108.0, 'mg/dL', '2025-03-02', 'a digiuno'),
    (1, 'Colesterolo totale', 195.0, 'mg/dL', '2025-03-02', NULL),
    (2, 'Glicemia', 126.0, 'mg/dL', '2025-02-15', NULL),
    (2, 'Hb', 14.1, 'g/dL', '2025-02-15', NULL),
    (3, 'Glicemia', 88.0, 'mg/dL', '2025-04-01', NULL),
    (3, 'Pressione sistolica', 118.0, 'mmHg', '2025-04-01', NULL);
