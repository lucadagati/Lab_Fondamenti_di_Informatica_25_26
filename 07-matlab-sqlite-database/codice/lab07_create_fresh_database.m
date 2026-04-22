function dbPath = lab07_create_fresh_database(labDir)
%LAB07_CREATE_FRESH_DATABASE Ricrea da zero il file SQLite del laboratorio.
%
%   dbPath = lab07_create_fresh_database(labDir)
%   labDir = cartella radice 07-matlab-sqlite-database.
%
%   Richiede Database Toolbox: sqlite, execute, close.
%   Glossario dei comandi MATLAB/SQLite: vedi anche esercizi/es01_apri_db_sqlread.m

    labDir = char(labDir);
    datiDir = fullfile(labDir, 'dati');
    if ~isfolder(datiDir)
        mkdir(datiDir);
    end

    dbPath = fullfile(datiDir, 'lab07_biomed.db');

    if isfile(dbPath)
        try
            delete(dbPath);
        catch ME
            error('lab07:dbDelete', '%s\nChiudi connessioni o programmi che usano il file.', ME.message);
        end
    end

    % sqlite(apreFile) crea l oggetto connessione; il file viene creato se non esiste
    conn = sqlite(dbPath);

    % PRAGMA = comando speciale SQLite; foreign_keys=ON attiva i controlli sulle FK
    execute(conn, 'PRAGMA foreign_keys=ON;');

    % CREATE TABLE definisce la tabella pazienti nel file .db
    execute(conn, [ ...
        'CREATE TABLE pazienti (' ...
        'id INTEGER PRIMARY KEY AUTOINCREMENT,' ...
        'nome TEXT NOT NULL,' ...
        'cognome TEXT NOT NULL,' ...
        'anno_nascita INTEGER,' ...
        'sesso TEXT CHECK (sesso IN (''M'', ''F'', ''X'')) DEFAULT ''X''' ...
        ');' ...
        ]);

    % REFERENCES … ON DELETE CASCADE: se cancello un paziente, SQLite rimuove i suoi esami
    execute(conn, [ ...
        'CREATE TABLE esami_lab (' ...
        'id INTEGER PRIMARY KEY AUTOINCREMENT,' ...
        'paziente_id INTEGER NOT NULL REFERENCES pazienti(id) ON DELETE CASCADE,' ...
        'nome_esame TEXT NOT NULL,' ...
        'valore REAL NOT NULL,' ...
        'unita TEXT NOT NULL,' ...
        'data_esame TEXT NOT NULL,' ...
        'note TEXT' ...
        ');' ...
        ]);

    % Ogni execute con INSERT aggiunge una riga; le stringhe SQL usano '' per l apostrofo
    execute(conn, 'INSERT INTO pazienti (nome, cognome, anno_nascita, sesso) VALUES (''Giulia'', ''Verdi'', 1992, ''F'');');
    execute(conn, 'INSERT INTO pazienti (nome, cognome, anno_nascita, sesso) VALUES (''Marco'', ''Bianchi'', 1985, ''M'');');
    execute(conn, 'INSERT INTO pazienti (nome, cognome, anno_nascita, sesso) VALUES (''Laura'', ''Neri'', 2001, ''F'');');

    execute(conn, 'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) VALUES (1, ''Glicemia'', 92.0, ''mg/dL'', ''2025-01-10'');');
    execute(conn, 'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame, note) VALUES (1, ''Glicemia'', 108.0, ''mg/dL'', ''2025-03-02'', ''a digiuno'');');
    execute(conn, 'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) VALUES (1, ''Colesterolo totale'', 195.0, ''mg/dL'', ''2025-03-02'');');
    execute(conn, 'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) VALUES (2, ''Glicemia'', 126.0, ''mg/dL'', ''2025-02-15'');');
    execute(conn, 'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) VALUES (2, ''Hb'', 14.1, ''g/dL'', ''2025-02-15'');');
    execute(conn, 'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) VALUES (3, ''Glicemia'', 88.0, ''mg/dL'', ''2025-04-01'');');
    execute(conn, 'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) VALUES (3, ''Pressione sistolica'', 118.0, ''mmHg'', ''2025-04-01'');');

    close(conn);
end
