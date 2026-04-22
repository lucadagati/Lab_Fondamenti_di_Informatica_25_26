#!/usr/bin/env bash
# Crea lab07_biomed.db da SQL (richiede sqlite3 nel PATH).
# Uso: dalla cartella 07-matlab-sqlite-database:  bash script_init_db.sh

set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
DB="$DIR/dati/lab07_biomed.db"
SQL="$DIR/sql/lab07_schema.sql"

mkdir -p "$DIR/dati"
rm -f "$DB"
sqlite3 "$DB" < "$SQL"
echo "Creato: $DB"
