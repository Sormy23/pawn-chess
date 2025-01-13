/*
Sven Oberwalder, Yasin Sahin
Pawn Chess
07.01.2025
*/

drop table if exists board;
drop table if exists gameState;

-- Tabelle für das Spielfeld
CREATE TABLE board (
    line INT CHECK (line BETWEEN 1 AND 8),
    a VARCHAR2(2),
    b VARCHAR2(2),
    c VARCHAR2(2),
    d VARCHAR2(2),
    e VARCHAR2(2),
    f VARCHAR2(2),
    g VARCHAR2(2),
    h VARCHAR2(2)
);

-- Tabelle für den Spielzustand
CREATE TABLE gameState (
    color CHAR(1) CHECK (color IN ('W', 'B')),
    isPlayer BOOLEAN,
    hasTurn BOOLEAN
);
