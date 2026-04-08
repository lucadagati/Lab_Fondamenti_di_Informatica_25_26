"""Soluzione esercizio 8."""

def min_max(valori: list[int]) -> tuple[int, int]:
    minimo = valori[0]
    massimo = valori[0]

    for v in valori:
        if v < minimo:
            minimo = v
        if v > massimo:
            massimo = v

    return minimo, massimo


def main() -> None:
    nums = [4, 19, 2, 8, 11]
    mn, mx = min_max(nums)
    print("Minimo:", mn)
    print("Massimo:", mx)


if __name__ == "__main__":
    main()
