# Diagrammi E-R progressivi

Questo file raccoglie solo i diagrammi, in sequenza, per mostrare la crescita del modello.

## D0 - Schema scheletro

```mermaid
erDiagram
    PARTECIPANTE }o--o{ CORSO : partecipa
    DOCENTE }o--o{ CORSO : insegna
```

## D1 - Introduzione edizioni

```mermaid
erDiagram
    CORSO ||--o{ EDIZIONE_CORSO : ha
    PARTECIPANTE }o--o{ EDIZIONE_CORSO : frequenta
    DOCENTE }o--o{ EDIZIONE_CORSO : docenza
```

## D2 - Composizione lezioni

```mermaid
erDiagram
    CORSO ||--o{ EDIZIONE_CORSO : ha
    EDIZIONE_CORSO ||--|{ LEZIONE : composta_da
    PARTECIPANTE }o--o{ EDIZIONE_CORSO : frequenta
    DOCENTE }o--o{ EDIZIONE_CORSO : docenza
```

## D3 - Storico impieghi

```mermaid
erDiagram
    PARTECIPANTE ||--o| IMPIEGO_CORRENTE : ha
    PARTECIPANTE ||--o{ IMPIEGO_PASSATO : ha
    DATORE_LAVORO ||--o{ IMPIEGO_CORRENTE : coinvolto
    DATORE_LAVORO ||--o{ IMPIEGO_PASSATO : coinvolto
```

## D4 - Modello ristrutturato finale

```mermaid
erDiagram
    CORSO ||--o{ EDIZIONE_CORSO : ha
    EDIZIONE_CORSO ||--|{ LEZIONE : composta_da

    PARTECIPANTE }o--o{ FREQUENZA : frequenta
    EDIZIONE_CORSO }o--o{ FREQUENZA : include

    DOCENTE }o--o{ DOCENZA : eroga
    EDIZIONE_CORSO }o--o{ DOCENZA : prevede

    PARTECIPANTE ||--o| IMPIEGO_CORRENTE : ha
    PARTECIPANTE ||--o{ IMPIEGO_PASSATO : ha
    DATORE_LAVORO ||--o{ IMPIEGO_CORRENTE : coinvolto
    DATORE_LAVORO ||--o{ IMPIEGO_PASSATO : coinvolto
```

## Variante Chen semplificata

```mermaid
flowchart LR
    P[PARTECIPANTE] --- F{FREQUENZA}
    E[EDIZIONE_CORSO] --- F
    D[DOCENTE] --- X{DOCENZA}
    E --- X
    C[CORSO] --- H{HA}
    E --- H
```
