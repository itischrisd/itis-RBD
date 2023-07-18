CREATE TABLE Stanowisko
(
    Id       NUMBER(10),
    Nazwa    VARCHAR2(35),
    Prowizja NUMBER(5, 2),
    CONSTRAINT PK_Stanowisko PRIMARY KEY (Id)
);

CREATE TABLE MetodaPlatnosci
(
    Id    NUMBER(10),
    Nazwa VARCHAR2(15) NOT NULL,
    CONSTRAINT PK_MetodaPlatnosci PRIMARY KEY (Id)
);

CREATE TABLE RodzajNaprawy
(
    Id    NUMBER(10),
    Nazwa VARCHAR2(60) NOT NULL,
    CONSTRAINT PK_RodzajNaprawy PRIMARY KEY (Id)
);

CREATE TABLE Marka
(
    Id    NUMBER(10),
    Nazwa VARCHAR2(30) NOT NULL,
    CONSTRAINT PK_Marka PRIMARY KEY (Id)
);

CREATE TABLE Kraj
(
    Id    NUMBER(10),
    Nazwa VARCHAR2(30) NOT NULL,
    CONSTRAINT PK_Kraj PRIMARY KEY (Id)
);

CREATE TABLE Adres
(
    Id          NUMBER(10),
    Ulica       VARCHAR2(100) NOT NULL,
    NrDomu      NUMBER(4)     NOT NULL,
    NrLokalu    NUMBER(4),
    KodPocztowy CHAR(6)       NOT NULL,
    Miasto      VARCHAR2(30)  NOT NULL,
    Poczta      VARCHAR2(30),
    CONSTRAINT PK_Adres PRIMARY KEY (Id)
);

CREATE TABLE DaneKontaktowe
(
    Id      NUMBER(10),
    Telefon NUMBER(10) NOT NULL,
    Email   VARCHAR2(50),
    CONSTRAINT PK_DaneKontaktowe PRIMARY KEY (Id)
);

CREATE TABLE Osoba
(
    Id               NUMBER(10),
    Imie             VARCHAR2(20) NOT NULL,
    Nazwisko         VARCHAR2(50) NOT NULL,
    AdresId          NUMBER(10)   NOT NULL,
    DaneKontaktoweId NUMBER(10)   NOT NULL,
    CONSTRAINT PK_Osoba PRIMARY KEY (Id),
    CONSTRAINT FK_Osoba_Adres FOREIGN KEY (AdresId) REFERENCES Adres,
    CONSTRAINT FK_Osoba_DaneKontaktowe FOREIGN KEY (DaneKontaktoweId) REFERENCES DaneKontaktowe
);

CREATE TABLE Klient
(
    OsobaId    NUMBER(10),
    NazwaFirmy VARCHAR2(100),
    NIP        NUMBER(10) UNIQUE,
    CONSTRAINT PK_Klient PRIMARY KEY (OsobaId),
    CONSTRAINT FK_Klient_Osoba FOREIGN KEY (OsobaId) REFERENCES Osoba
);

CREATE TABLE Pracownik
(
    OsobaId           NUMBER(10),
    PrzelozonyId      NUMBER(10),
    StanowiskoId      NUMBER(10)   NOT NULL,
    DataZatrudnienia  DATE         NOT NULL,
    DataWypowiedzenia DATE,
    Pensja            NUMBER(7, 2) NOT NULL,
    CONSTRAINT PK_Pracownik PRIMARY KEY (OsobaId),
    CONSTRAINT FK_Pracownik_Osoba FOREIGN KEY (OsobaId) REFERENCES Osoba,
    CONSTRAINT FK_Pracownik_Pracownik FOREIGN KEY (OsobaId) REFERENCES Pracownik,
    CONSTRAINT FK_Pracownik_Stanowisko FOREIGN KEY (StanowiskoId) REFERENCES Stanowisko
);

CREATE TABLE Samochod
(
    VIN             CHAR(17),
    MarkaId         NUMBER(10)   NOT NULL,
    Model           VARCHAR2(20) NOT NULL,
    KrajProdukcjiId NUMBER(10)   NOT NULL,
    RokProdukcji    NUMBER(4)    NOT NULL,
    Przebieg        NUMBER(7)    NOT NULL,
    MocSilnika      NUMBER(4)    NOT NULL,
    Kolor           VARCHAR2(15) NOT NULL,
    Wycena          NUMBER(6)    NOT NULL,
    CONSTRAINT PK_Samochod PRIMARY KEY (VIN),
    CONSTRAINT FK_Samochod_Marka FOREIGN KEY (MarkaId) REFERENCES Marka,
    CONSTRAINT FK_Samochod_Kraj FOREIGN KEY (KrajProdukcjiId) REFERENCES Kraj
);

CREATE TABLE KupnoSprzedaz
(
    Id                NUMBER(10),
    SamochodVIN       CHAR(17)   NOT NULL,
    KlientId          NUMBER(10) NOT NULL,
    PracownikId       NUMBER(10) NOT NULL,
    WartoscTransakcji NUMBER(6)  NOT NULL,
    DataKupna         DATE,
    DataSprzedazy     DATE,
    MetodaPlatnosciId NUMBER(10) NOT NULL,
    CONSTRAINT PK_KupnoSprzedaz PRIMARY KEY (Id),
    CONSTRAINT FK_KupnoSprzedaz_Samochod FOREIGN KEY (SamochodVIN) REFERENCES Samochod,
    CONSTRAINT FK_KupnoSprzedaz_Klient FOREIGN KEY (KlientId) REFERENCES Klient,
    CONSTRAINT FK_KupnoSprzedaz_Pracownik FOREIGN KEY (PracownikId) REFERENCES Pracownik,
    CONSTRAINT FK_KupnoSprzedaz_MetodaPlatnosci FOREIGN KEY (MetodaPlatnosciId) REFERENCES MetodaPlatnosci
);

CREATE TABLE AutoryzowanySerwis
(
    Id               NUMBER(10),
    AdresId          NUMBER(10)   NOT NULL,
    Nazwa            VARCHAR2(30) NOT NULL,
    DaneKontaktoweId NUMBER(10)   NOT NULL,
    CONSTRAINT PK_AutoryzowanySerwis PRIMARY KEY (Id),
    CONSTRAINT FK_AutoryzowanySerwis_Adres FOREIGN KEY (AdresId) REFERENCES Adres,
    CONSTRAINT FK_AutoryzowanySerwis_DaneKontaktowe FOREIGN KEY (DaneKontaktoweId) REFERENCES DaneKontaktowe
);

CREATE TABLE AutoryzowanySerwisRodzajNaprawy
(
    AutoryzowanySerwisId NUMBER(10) NOT NULL,
    RodzajNaprawyId      NUMBER(10) NOT NULL,
    CONSTRAINT PK_AutoryzowanySerwisRodzajNaprawy PRIMARY KEY (AutoryzowanySerwisId, RodzajNaprawyId),
    CONSTRAINT FK_AutoryzowanySerwisRodzajNaprawy_AutoryzowanySerwis FOREIGN KEY (AutoryzowanySerwisId) REFERENCES AutoryzowanySerwis,
    CONSTRAINT FK_AutoryzowanySerwisRodzajNaprawy_RodzajNaprawy FOREIGN KEY (RodzajNaprawyId) REFERENCES RodzajNaprawy
);

CREATE TABLE AutoryzowanySerwisMarka
(
    AutoryzowanySerwisId NUMBER(10) NOT NULL,
    MarkaId              NUMBER(10) NOT NULL,
    CONSTRAINT PK_AutoryzowanySerwisMarka PRIMARY KEY (AutoryzowanySerwisId, MarkaId),
    CONSTRAINT FK_AutoryzowanySerwisMarka_AutoryzowanySerwis FOREIGN KEY (AutoryzowanySerwisId) REFERENCES AutoryzowanySerwis,
    CONSTRAINT FK_AutoryzowanySerwisMarka_MarkaId FOREIGN KEY (MarkaId) REFERENCES Marka
);