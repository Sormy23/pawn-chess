/*
Sven Oberwalder, Yasin Sahin
Pawn Chess
07.01.2025
*/

-- gets the varchar stored of a square
CREATE OR REPLACE FUNCTION getSquare(square VARCHAR2) RETURN VARCHAR2 AS
    column_name CHAR(1);
    line INT;
    square_content VARCHAR2(2);
BEGIN
    column_name := UPPER(SUBSTR(square, 1, 1));
    line := TO_NUMBER(SUBSTR(square, 2, LENGTH(square) - 1));

    IF column_name NOT BETWEEN 'A' AND 'H' OR line NOT BETWEEN 1 AND 8 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid square: ' || square);
    END IF;

    EXECUTE IMMEDIATE 'SELECT ' || column_name || ' FROM board WHERE line = :line'
        INTO square_content
        USING line;

    RETURN square_content;
END;
/


-- Prüft, ob ein Bauer existiert
CREATE OR REPLACE FUNCTION doesPawnExist(color varchar2, square VARCHAR2) RETURN BOOLEAN AS
BEGIN
    RETURN (getSquare(square) = color); 
END;
/


-- Prüft, ob ein Bauer sich bewegen kann
CREATE OR REPLACE FUNCTION canMovePawn(f VARCHAR2, t VARCHAR2) RETURN BOOLEAN AS
    from_line INT;
    to_line INT;
    from_column varchar(1);
    to_column varchar(1);
    color varchar2(2);
    from_square VARCHAR2(2);
    to_square VARCHAR2(2);
BEGIN
    from_square := upper(f);
    to_square := upper(t);
    from_line := TO_NUMBER(SUBSTR(from_square, 2, 1));
    to_line := TO_NUMBER(SUBSTR(to_square, 2, 1));
    from_column := SUBSTR(from_square, 1, 1);
    to_column := SUBSTR(to_square, 1, 1);

    SELECT gs.COLOR into color FROM gameState gs WHERE hasTurn = TRUE;

    IF NOT doesPawnExist(color, from_square) THEN
        dbms_output.PUT_LINE('Pawn' || color || 'does not exist on ' || from_square);
        RETURN FALSE;
    END IF;

    
    IF from_column = to_column THEN
        -- moving forward
        IF (color = 'W' AND from_line = 2) THEN
            RETURN ((to_line = from_line + 1 AND getSquare(to_square) = ' ') OR (to_line = from_line + 2) AND getSquare(to_square) = ' ');
        ELSIF (color = 'B' AND from_line = 7) THEN
            RETURN ((to_line = from_line - 1 AND getSquare(to_square) = ' ') OR (to_line = from_line - 2) AND getSquare(to_square) = ' ');
        ELSIF (color = 'W') THEN
            RETURN (to_line = from_line + 1 AND getSquare(to_square) = ' ');
        ELSIF (color = 'B') THEN
            RETURN (to_line = from_line - 1 AND getSquare(to_square) = ' ');
        END IF;
    ELSE -- punching someone in the face
        if (color = 'W') then 
            RETURN (to_line = from_line + 1 AND ABS(ASCII(to_column) - ASCII(from_column)) = 1 AND (getSquare(to_square) = 'B' or getSquare(to_square) = 'PB'));
            
        elsif (color = 'B') then
            RETURN (to_line = from_line - 1 AND ABS(ASCII(to_column) - ASCII(from_column)) = 1 AND (getSquare(to_square) = 'W' or getSquare(to_square) = 'PW'));
        end if;
    END IF;
END;
/


-- Gibt das Spielende zurück
CREATE OR REPLACE FUNCTION getEndCondition RETURN VARCHAR2 AS
    white_win BOOLEAN := FALSE;
    black_win BOOLEAN := FALSE;
    count_check INT;
BEGIN
    -- Check if white has won
    SELECT COUNT(*)
    INTO count_check
    FROM board
    WHERE line = 8 AND 'W' IN (a, b, c, d, e, f, g, h);

    white_win := count_check > 0;

    -- Check if black has won
    SELECT COUNT(*)
    INTO count_check
    FROM board
    WHERE line = 1 AND 'B' IN (a, b, c, d, e, f, g, h);

    black_win := count_check > 0;

    -- Return result
    IF white_win THEN
        RETURN 'W';
    ELSIF black_win THEN
        RETURN 'B';
    ELSE
        -- Check for draw
        SELECT COUNT(*)
        INTO count_check
        FROM board
        WHERE 'W' IN (a, b, c, d, e, f, g, h) OR 'B' IN (a, b, c, d, e, f, g, h);

        IF count_check = 0 THEN
            RETURN 'D';
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
/