-- Lab 07 — schema didattico esteso (SQLite, 7 tabelle + view + indici)
-- Modello semplificato LIS/HIS: reparti → medici/pazienti; visite; catalogo
-- tipi di esame; risultati (esami_lab) legati alla visita e al tipo.
-- Uso: sqlite3 ../dati/lab07_biomed.db < lab07_schema.sql (da cartella sql/)

PRAGMA foreign_keys = ON;

DROP VIEW IF EXISTS v_esami_completi;
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS esami_lab;
DROP TABLE IF EXISTS visite;
DROP TABLE IF EXISTS medici;
DROP TABLE IF EXISTS pazienti;
DROP TABLE IF EXISTS tipi_esame;
DROP TABLE IF EXISTS reparti;

-- Reparti ospedalieri (contesto organizzativo; medici e pazienti possono essere associati).
CREATE TABLE reparti (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    nome         TEXT NOT NULL,
    piano        INTEGER,
    descrizione  TEXT
);

-- Medici: anagrafica minima collegata al reparto di appartenenza.
CREATE TABLE medici (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    nome         TEXT NOT NULL,
    cognome      TEXT NOT NULL,
    reparto_id   INTEGER NOT NULL REFERENCES reparti(id) ON DELETE RESTRICT,
    specialita   TEXT
);

-- Pazienti: anagrafica; reparto_id opzionale (es. reparto di ricovero o ambulatorio di riferimento).
CREATE TABLE pazienti (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    nome          TEXT NOT NULL,
    cognome       TEXT NOT NULL,
    anno_nascita  INTEGER,
    sesso         TEXT CHECK (sesso IN ('M', 'F', 'X')) DEFAULT 'X',
    reparto_id    INTEGER REFERENCES reparti(id) ON DELETE SET NULL
);

-- Catalogo prestazioni di laboratorio (normalmente tabella di configurazione LIS).
CREATE TABLE tipi_esame (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    codice        TEXT NOT NULL UNIQUE,
    nome          TEXT NOT NULL,
    unita_ref     TEXT NOT NULL,
    valore_min    REAL,
    valore_max    REAL
);

-- Visita clinica: collega paziente e medico in una data (contesto in cui ha senso richiedere esami).
CREATE TABLE visite (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    paziente_id   INTEGER NOT NULL REFERENCES pazienti(id) ON DELETE CASCADE,
    medico_id     INTEGER NOT NULL REFERENCES medici(id) ON DELETE RESTRICT,
    data_visita   TEXT NOT NULL,
    motivo        TEXT
);

-- Risultato di laboratorio: FK a visita (contesto) e a tipo (definizione del test).
CREATE TABLE esami_lab (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    visita_id       INTEGER NOT NULL REFERENCES visite(id) ON DELETE CASCADE,
    tipo_esame_id   INTEGER NOT NULL REFERENCES tipi_esame(id) ON DELETE RESTRICT,
    valore          REAL NOT NULL,
    unita           TEXT NOT NULL,
    data_risultato  TEXT NOT NULL,
    note            TEXT
);

CREATE TABLE audit_log (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    tabella      TEXT NOT NULL,
    operazione   TEXT NOT NULL,
    riga_id      INTEGER,
    descrizione  TEXT,
    data_evento  TEXT DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO reparti (nome, piano, descrizione) VALUES
    ('Biochimica clinica', 2, 'Laboratorio centrale: biochimica, immunologia, ormoni'),
    ('Ematologia', 4, 'Emocromo, coagulazione, emoglobinurie'),
    ('Medicina interna', 3, 'Degenza e follow-up metabolico'),
    ('Endocrinologia', 5, 'Ambulatorio diabete, tiroide e metabolismo'),
    ('Pronto soccorso', 0, 'Accessi urgenti e prime valutazioni cliniche');

INSERT INTO medici (nome, cognome, reparto_id, specialita) VALUES
    ('Anna', 'Rossi', 1, 'Patologia clinica'),
    ('Luca', 'Gallo', 1, 'Endocrinologia e diabetologia'),
    ('Chiara', 'Marta', 3, 'Medicina interna'),
    ('Filippo', 'Neri', 2, 'Ematologia clinica'),
    ('Serena', 'Conti', 4, 'Endocrinologia'),
    ('Davide', 'Russo', 5, 'Medicina d urgenza');

INSERT INTO pazienti (nome, cognome, anno_nascita, sesso, reparto_id) VALUES
    ('Giulia', 'Verdi', 1992, 'F', 1),
    ('Marco', 'Bianchi', 1985, 'M', 1),
    ('Laura', 'Neri', 2001, 'F', 2),
    ('Paolo', 'Blu', 1978, 'M', 3),
    ('Sara', 'Romano', 1968, 'F', 4),
    ('Ahmed', 'Khan', 1998, 'M', 5),
    ('Elena', 'Costa', 1955, 'F', 3),
    ('Marta', 'Greco', 2010, 'F', 2),
    ('Nicola', 'Ferrari', 1970, 'M', 4),
    ('Irene', 'Moretti', 1989, 'F', NULL);

INSERT INTO tipi_esame (codice, nome, unita_ref, valore_min, valore_max) VALUES
    ('GLU', 'Glicemia', 'mg/dL', 70, 100),
    ('HGB', 'Emoglobina', 'g/dL', 12.0, 16.0),
    ('CHOL', 'Colesterolo totale', 'mg/dL', NULL, 200),
    ('PCR', 'PCR quantitativa', 'mg/dL', NULL, 5),
    ('LDH', 'LDH', 'U/L', 140, 280),
    ('FERR', 'Ferritina', 'ng/mL', 20, 300),
    ('CREA', 'Creatinina', 'umol/L', 59, 104),
    ('PAS', 'Pressione sistolica', 'mmHg', 90, 140),
    ('WBC', 'Leucociti', '10^9/L', 4.0, 10.0),
    ('PLT', 'Piastrine', '10^9/L', 150, 450),
    ('ALT', 'ALT', 'U/L', NULL, 45),
    ('TSH', 'TSH', 'mIU/L', 0.4, 4.0),
    ('NA', 'Sodio', 'mmol/L', 135, 145),
    ('K', 'Potassio', 'mmol/L', 3.5, 5.1);

INSERT INTO visite (paziente_id, medico_id, data_visita, motivo) VALUES
    (1, 1, '2025-01-10', 'Controllo metabolico e profilo lipidico'),
    (1, 2, '2025-03-02', 'Follow-up glicemia e colesterolo'),
    (2, 1, '2025-02-15', 'Primo accesso per iperglicemia'),
    (3, 3, '2025-04-01', 'Screening pre-operatorio'),
    (4, 4, '2025-04-05', 'Controllo post-dimissioni'),
    (2, 2, '2025-05-10', 'Visita ambulatoriale diabetologica'),
    (5, 5, '2025-05-12', 'Controllo tiroideo e metabolismo'),
    (6, 6, '2025-05-13', 'Accesso urgente per disidratazione'),
    (7, 3, '2025-05-14', 'Controllo insufficienza renale lieve'),
    (8, 4, '2025-05-15', 'Emocromo pediatrico di controllo'),
    (9, 5, '2025-06-01', 'Follow-up diabete tipo 2'),
    (10, 1, '2025-06-03', 'Screening generale annuale'),
    (1, 1, '2025-06-10', 'Ricontrollo dopo dieta'),
    (2, 5, '2025-06-12', 'Secondo follow-up glicemico');

INSERT INTO esami_lab (visita_id, tipo_esame_id, valore, unita, data_risultato, note) VALUES
    (1, 1, 92.0, 'mg/dL', '2025-01-10', NULL),
    (1, 7, 88.0, 'umol/L', '2025-01-10', 'eGFR stabile'),
    (2, 1, 108.0, 'mg/dL', '2025-03-02', 'a digiuno'),
    (2, 3, 195.0, 'mg/dL', '2025-03-02', NULL),
    (2, 8, 122.0, 'mmHg', '2025-03-02', 'PA al momento del prelievo'),
    (3, 1, 126.0, 'mg/dL', '2025-02-15', NULL),
    (3, 2, 14.1, 'g/dL', '2025-02-15', NULL),
    (4, 1, 88.0, 'mg/dL', '2025-04-01', NULL),
    (4, 8, 118.0, 'mmHg', '2025-04-01', NULL),
    (5, 2, 13.2, 'g/dL', '2025-04-05', NULL),
    (5, 4, 2.1, 'mg/dL', '2025-04-05', 'infiammazione lieve'),
    (1, 3, 178.0, 'mg/dL', '2025-01-10', 'primo campione del profilo'),
    (6, 1, 119.0, 'mg/dL', '2025-05-10', 'controllo a digiuno'),
    (6, 5, 230.0, 'U/L', '2025-05-10', NULL),
    (6, 4, 0.4, 'mg/dL', '2025-05-10', NULL),
    (7, 12, 5.8, 'mIU/L', '2025-05-12', 'TSH lievemente alto'),
    (7, 1, 101.0, 'mg/dL', '2025-05-12', NULL),
    (8, 13, 132.0, 'mmol/L', '2025-05-13', 'iponatriemia lieve'),
    (8, 14, 3.2, 'mmol/L', '2025-05-13', 'potassio basso'),
    (8, 7, 110.0, 'umol/L', '2025-05-13', 'disidratazione sospetta'),
    (9, 7, 118.0, 'umol/L', '2025-05-14', 'sopra range'),
    (9, 13, 139.0, 'mmol/L', '2025-05-14', NULL),
    (9, 14, 4.7, 'mmol/L', '2025-05-14', NULL),
    (10, 9, 7.2, '10^9/L', '2025-05-15', NULL),
    (10, 10, 310.0, '10^9/L', '2025-05-15', NULL),
    (10, 2, 12.4, 'g/dL', '2025-05-15', NULL),
    (11, 1, 142.0, 'mg/dL', '2025-06-01', 'valore alto'),
    (11, 3, 222.0, 'mg/dL', '2025-06-01', 'sopra soglia'),
    (11, 6, 340.0, 'ng/mL', '2025-06-01', 'sopra range'),
    (12, 1, 83.0, 'mg/dL', '2025-06-03', NULL),
    (12, 11, 32.0, 'U/L', '2025-06-03', NULL),
    (12, 12, 2.1, 'mIU/L', '2025-06-03', NULL),
    (13, 1, 96.0, 'mg/dL', '2025-06-10', 'miglioramento'),
    (13, 3, 181.0, 'mg/dL', '2025-06-10', NULL),
    (14, 1, 111.0, 'mg/dL', '2025-06-12', 'da ricontrollare'),
    (14, 8, 136.0, 'mmHg', '2025-06-12', NULL);

CREATE INDEX idx_visite_paziente ON visite(paziente_id);
CREATE INDEX idx_esami_visita ON esami_lab(visita_id);
CREATE INDEX idx_esami_tipo ON esami_lab(tipo_esame_id);

CREATE VIEW v_esami_completi AS
SELECT e.id AS esame_id,
       p.cognome,
       p.nome,
       v.data_visita,
       m.cognome AS medico,
       r.nome AS reparto,
       t.codice,
       t.nome AS esame,
       e.valore,
       e.unita,
       t.valore_min,
       t.valore_max,
       e.data_risultato,
       e.note
FROM esami_lab e
JOIN visite v ON v.id = e.visita_id
JOIN pazienti p ON p.id = v.paziente_id
JOIN medici m ON m.id = v.medico_id
LEFT JOIN reparti r ON r.id = p.reparto_id
JOIN tipi_esame t ON t.id = e.tipo_esame_id;
