"""Soluzione esercizio 5."""

def main() -> None:
    coppie = [("Luca", 3), ("Anna", 1), ("Marta", 2)]

    # Ordinamento esplicito (selection sort) sul secondo elemento
    ordinate = coppie[:]
    n = len(ordinate)
    i = 0
    while i < n - 1:
        min_idx = i
        j = i + 1
        while j < n:
            if ordinate[j][1] < ordinate[min_idx][1]:
                min_idx = j
            j += 1
        if min_idx != i:
            tmp = ordinate[i]
            ordinate[i] = ordinate[min_idx]
            ordinate[min_idx] = tmp
        i += 1

    print(ordinate)


if __name__ == "__main__":
    main()
