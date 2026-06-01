#!/usr/bin/env bash
# Script DIDATTICO per laboratorio crittografia - attacco dictionary su file AES
# Utilizzo: creare prima referto_debole.enc con password debole, es.:
#   openssl enc -aes-256-cbc -salt -in referto.txt -out referto_debole.enc -pass pass:1234

set -e

REFERTO_ENC="${1:-referto_debole.enc}"
DIZIONARIO="${2:-passwords.txt}"
OUT_TEST="test_decifrato.txt"

if [ ! -f "$REFERTO_ENC" ]; then
  echo "File cifrato non trovato: $REFERTO_ENC"
  echo "Creane uno con password debole, ad esempio:"
  echo "  openssl enc -aes-256-cbc -salt -in referto.txt -out referto_debole.enc -pass pass:1234"
  exit 1
fi

if [ ! -f "$DIZIONARIO" ]; then
  echo "Dizionario non trovato: $DIZIONARIO"
  exit 1
fi

echo "=== Attacco dictionary (didattico) ==="
echo "File da attaccare: $REFERTO_ENC"
echo "Dizionario: $DIZIONARIO"
echo ""

while IFS= read -r p || [ -n "$p" ]; do
  # Rimuovi spazi/carriage return
  p=$(echo "$p" | tr -d '\r')
  [ -z "$p" ] && continue
  printf "Provo password: %s ... " "$p"
  if openssl enc -d -aes-256-cbc -in "$REFERTO_ENC" -out "$OUT_TEST" -pass "pass:$p" 2>/dev/null; then
    echo "OK"
    echo ""
    echo "*** PASSWORD TROVATA: $p ***"
    echo "Contenuto decifrato (prime righe):"
    head -5 "$OUT_TEST" 2>/dev/null || cat "$OUT_TEST"
    rm -f "$OUT_TEST"
    exit 0
  else
    echo "no"
  fi
done < "$DIZIONARIO"

echo ""
echo "Nessuna password del dizionario ha funzionato."
echo "In un attacco reale si userebbero dizionari molto più grandi."
exit 1
