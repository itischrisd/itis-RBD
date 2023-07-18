-- 1. Klient zakupił auto marki Ford. Stwórz dla niego listę, dzięki której będzie mógł sprawdzić w jakich warsztatach
-- będzie mógł dokonać różnego rodzaju naprawy. W liście zawrzyj numery kontaktowe do warsztatów.

SELECT R.NAZWA AS "Naprawa", A2.NAZWA AS "Warsztat", D.TELEFON AS "Telefon kontaktowy"
FROM RODZAJNAPRAWY R
         INNER JOIN AUTORYZOWANYSERWISRODZAJNAPRAWY A1 ON R.ID = A1.RODZAJNAPRAWYID
         INNER JOIN AUTORYZOWANYSERWIS A2 ON A2.ID = A1.AUTORYZOWANYSERWISID
         INNER JOIN DANEKONTAKTOWE D ON A2.DANEKONTAKTOWEID = D.ID
         INNER JOIN AUTORYZOWANYSERWISMARKA A3 ON A2.ID = A3.AUTORYZOWANYSERWISID
         INNER JOIN MARKA M ON A3.MARKAID = M.ID
WHERE M.NAZWA = 'Ford'
ORDER BY R.NAZWA;

-- 2. Klientami komisu bywają osoby, dla których ważnym aspektem jest kolor karoserii pojazdu. Napisz zapytanie, które
-- wyświetli ilość modeli samochodów według marek i kolorów.

SELECT M.NAZWA AS "Marka", S.KOLOR AS "Kolor karoserii", COUNT(*) AS "Ilość"
FROM MARKA M
         INNER JOIN SAMOCHOD S ON M.ID = S.MARKAID
GROUP BY M.NAZWA, S.KOLOR
ORDER BY M.NAZWA;

-- 3. Komis sprzedaje auta po cenach, które mogą odbiegać od faktycznej, wycenionej wartości pojazdu. Stwórz zapytanie,
-- które wypisze markę i model pojazdu, kwotę, na którą go wyceniono, kwotę transakcji sprzedaży auta oraz wysokość
-- rozbieżności między nimi.

SELECT M.NAZWA                        AS "Marka",
       S.MODEL                        AS "Model",
       S.WYCENA                       AS "Kwota wyceny",
       K.WARTOSCTRANSAKCJI            AS "Kwota sprzedaży",
       K.WARTOSCTRANSAKCJI - S.WYCENA AS "Rozbieżność"
FROM KUPNOSPRZEDAZ K
         INNER JOIN SAMOCHOD S ON S.VIN = K.SAMOCHODVIN
         INNER JOIN MARKA M ON M.ID = S.MARKAID
WHERE K.DATASPRZEDAZY IS NOT NULL
ORDER BY M.NAZWA, S.MODEL;

-- 4. Szef komisu spodziewa się, że najbardziej intratnych transakcji dokonują managerzy. Napisz zapytanie, które
-- wyświetli kupna i sprzedaże dokonane przez pracowników na stanowiskach managerskich na kwoty powyżej średniej
-- wartości transakcji (w grupie wszystkich pracowników).

SELECT K.*
FROM KUPNOSPRZEDAZ K
         INNER JOIN PRACOWNIK P ON P.OSOBAID = K.PRACOWNIKID
         INNER JOIN STANOWISKO S ON S.ID = P.STANOWISKOID
WHERE S.NAZWA = 'Manager'
  AND WARTOSCTRANSAKCJI > (SELECT AVG(WARTOSCTRANSAKCJI) FROM KUPNOSPRZEDAZ)
ORDER BY K.ID;

-- 5. Przygotuj listę imion, nazwisk i adresów e-mail klientów, aby zapisać ich do elektronicznego newslettera
-- (zakładamy posiadanie zgody na komunikację marketingową). Nie uwzględniaj adresów e-mail pracowników.

SELECT O.IMIE, O.NAZWISKO, D.EMAIL
FROM OSOBA O
         INNER JOIN DANEKONTAKTOWE D ON D.ID = O.DANEKONTAKTOWEID
WHERE D.EMAIL IS NOT NULL
  AND EXISTS(SELECT * FROM KLIENT K WHERE K.OSOBAID = O.ID);

-- 6. Komis planuje wprowadzić kartę stałego klienta. Przygotuj ranking wyświetlający dane o klientach w kolejności
-- malejącej według liczby dokonanych transakcji.

SELECT COUNT(*) AS "Liczba transakcji", O.ID AS "ID Klienta", O.IMIE, O.NAZWISKO
FROM OSOBA O
         INNER JOIN KUPNOSPRZEDAZ K ON O.ID = K.KLIENTID
GROUP BY O.ID, O.IMIE, O.NAZWISKO
ORDER BY COUNT(*) DESC;

-- 7. Kadrowa chce wypłacić pensje pracownikom za ostatni miesiąc (grudzień 2021). Przygotuj dla niej tabelę pracowników
-- wraz z wysokością wypłat, biorąc pod uwagę prowizje za sprzedaż dla odpowiednich pracowników.

SELECT O.ID                                                                                    AS "ID Pracownika",
       O.IMIE,
       O.NAZWISKO,
       P.PENSJA,
       (SELECT SUM(WARTOSCTRANSAKCJI)
        FROM KUPNOSPRZEDAZ K
        WHERE K.PRACOWNIKID = O.ID
          AND TO_CHAR(K.DATASPRZEDAZY, 'MM-YYYY') = '12-2021') * S.PROWIZJA                    AS Prowizje,
       NVL((SELECT SUM(WARTOSCTRANSAKCJI)
            FROM KUPNOSPRZEDAZ K
            WHERE K.PRACOWNIKID = O.ID
              AND TO_CHAR(K.DATASPRZEDAZY, 'MM-YYYY') = '12-2021') * S.PROWIZJA, 0) + P.PENSJA AS "Pensja + prowizje"
FROM OSOBA O
         INNER JOIN PRACOWNIK P ON O.ID = P.OSOBAID
         INNER JOIN STANOWISKO S ON S.ID = P.STANOWISKOID
ORDER BY O.ID;

-- 8. Szef komisu na koniec 2021 roku chciałby rozważyć podwyżki dla pracowników działu sprzedaży. Przygotuj listę
-- pracowników wraz z ich sumą prowizji za transakcje w całym roku.

SELECT O.ID                                                           AS "ID Pracownika",
       O.IMIE,
       O.NAZWISKO,
       (SELECT SUM(WARTOSCTRANSAKCJI)
        FROM KUPNOSPRZEDAZ K
        WHERE K.PRACOWNIKID = O.ID
          AND TO_CHAR(K.DATASPRZEDAZY, 'YYYY') = '2021') * S.PROWIZJA AS Prowizje
FROM OSOBA O
         INNER JOIN PRACOWNIK P ON O.ID = P.OSOBAID
         INNER JOIN STANOWISKO S ON S.ID = P.STANOWISKOID
WHERE S.PROWIZJA IS NOT NULL
ORDER BY Prowizje DESC;

-- 9. Prowizje to nie wszystko, wszak liczone są od wartości transakcji, a nie faktycznego zysku dla firmy. Stwórz listę
-- pracowników, którzy w 2021 roku przynieśli komisowi straty, sprzedając samochody poniżej ich wyceny. Być może trzeba
-- ich zwolnić...

SELECT *
FROM (SELECT O.ID,
             O.IMIE,
             O.NAZWISKO,
             (SELECT SUM(K.WARTOSCTRANSAKCJI - S.WYCENA)
              FROM KUPNOSPRZEDAZ K
                       INNER JOIN SAMOCHOD S ON S.VIN = K.SAMOCHODVIN
              WHERE K.PRACOWNIKID = O.ID
                AND TO_CHAR(K.DATASPRZEDAZY, 'YYYY') = '2021'
              GROUP BY K.PRACOWNIKID) AS STRATA
      FROM OSOBA O
               INNER JOIN PRACOWNIK P ON O.ID = P.OSOBAID)
WHERE STRATA < 0
ORDER BY STRATA;

-- 10. Koniec roku to również czas inwentaryzacji. Część samochodów, które komis kupił od klientów, zostało już
-- sprzedanych. Przygotuj listę takich pojazdów.

SELECT S.VIN,
       M.NAZWA AS "MARKA",
       S.MODEL,
       K.NAZWA AS "KRAJ",
       S.ROKPRODUKCJI,
       S.PRZEBIEG,
       S.MOCSILNIKA,
       S.KOLOR,
       S.WYCENA
FROM SAMOCHOD S
         INNER JOIN KUPNOSPRZEDAZ K1 ON S.VIN = K1.SAMOCHODVIN
         INNER JOIN MARKA M ON M.ID = S.MARKAID
         INNER JOIN KRAJ K ON K.ID = S.KRAJPRODUKCJIID
WHERE K1.DATAKUPNA IS NOT NULL
  AND EXISTS(SELECT * FROM KUPNOSPRZEDAZ K2 WHERE K1.SAMOCHODVIN = K2.SAMOCHODVIN AND K2.DATASPRZEDAZY IS NOT NULL);