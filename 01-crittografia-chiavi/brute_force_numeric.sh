#!/usr/bin/env bash
# Script DIDATTICO - Brute force SENZA dizionario: prova tutte le combinazioni numeriche
# (es. 4 cifre: 0000, 0001, ... 9999). Per password solo numeriche e lunghezza limitata.
# Utilizzo:
#   ./brute_force_numeric.sh referto_debole.enc
#   ./brute_force_numeric.sh referto_debole.enc 4
#   ./brute_force_numeric.sh referto_debole.enc 6
# Creare il file cifrato con password numerica, es.:
#   openssl enc -aes-256-cbc -salt -in referto.txt -out referto_debole.enc -pass pass:1234

set -e

REFERTO_ENC="${1:-referto_debole.enc}"
LUNGHEZZA="${2:-4}"
OUT_TEST="test_decifrato_brute.txt"

if [ ! -f "$REFERTO_ENC" ]; then
  echo "File cifrato non trovato: $REFERTO_ENC"
  echo "Utilizzo: $0 <file.enc> [lunghezza_cifre]"
  echo "  lunghezza_cifre: 4 = 0000..9999 (default), 5 = 00000..99999, ecc."
  exit 1
fi

# Limite didattico: max 6 cifre (1 milione di tentativi)
if [ "$LUNGHEZZA" -lt 1 ] 2>/dev/null || [ "$LUNGHEZZA" -gt 6 ] 2>/dev/null; then
  echo "Lunghezza deve essere tra 1 e 6 (didattico). Ricevuto: $LUNGHEZZA"
  exit 1
fi

MAX=$((10 ** LUNGHEZZA - 1))
TOTALE=$((10 ** LUNGHEZZA))
echo "=== Brute force numerico (senza dizionario) ==="
echo "File: $REFERTO_ENC"
echo "Spazio: password numeriche da $LUNGHEZZA cifra/e (0 a $MAX) = $TOTALE tentativi"
echo ""

i=0
while [ "$i" -le "$MAX" ]; do
  # Formatta con zeri a sinistra (es. 4 cifre -> 0000, 0123, 1234)
  p=$(printf "%0${LUNGHEZZA}d" "$i")
  printf "\rProvo: %s (%d/%d) ... " "$p" "$((i+1))" "$TOTALE"
  if openssl enc -d -aes-256-cbc -in "$REFERTO_ENC" -out "$OUT_TEST" -pass "pass:$p" 2>/dev/null; then
    echo ""
    echo ""
    echo "*** PASSWORD TROVATA (brute force): $p ***"
    echo "Contenuto decifrato (prime righe):"
    head -5 "$OUT_TEST" 2>/dev/null || cat "$OUT_TEST"
    rm -f "$OUT_TEST"
    exit 0
  fi
  i=$((i + 1))
done

echo ""
echo "Nessuna password numerica di $LUNGHEZZA cifre ha funzionato."
echo "Provare con lunghezza diversa (es. $0 $REFERTO_ENC 5) o usare l'attacco a dizionario."
rm -f "$OUT_TEST"
exit 1
