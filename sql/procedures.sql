/*
Sven Oberwalder, Yasin Sahin
Pawn Chess
07.01.2025
*/

-- Setzt das Spielfeld zurück
CREATE OR REPLACE PROCEDURE resetBoard AS
BEGIN
    DELETE FROM board;
    FOR i IN 1..8 LOOP
        INSERT INTO board VALUES (
            i,
            CASE WHEN i = 2 THEN 'W' WHEN i = 7 THEN 'B' ELSE ' ' END,
            CASE WHEN i = 2 THEN 'W' WHEN i = 7 THEN 'B' ELSE ' ' END,
            CASE WHEN i = 2 THEN 'W' WHEN i = 7 THEN 'B' ELSE ' ' END,
            CASE WHEN i = 2 THEN 'W' WHEN i = 7 THEN 'B' ELSE ' ' END,
            CASE WHEN i = 2 THEN 'W' WHEN i = 7 THEN 'B' ELSE ' ' END,
            CASE WHEN i = 2 THEN 'W' WHEN i = 7 THEN 'B' ELSE ' ' END,
            CASE WHEN i = 2 THEN 'W' WHEN i = 7 THEN 'B' ELSE ' ' END,
            CASE WHEN i = 2 THEN 'W' WHEN i = 7 THEN 'B' ELSE ' ' END
        );
    END LOOP;
END;
/

-- Initialisiert den Spielzustand
CREATE OR REPLACE PROCEDURE initGameState(two_players BOOLEAN, player_begins BOOLEAN) AS
BEGIN
    DELETE FROM gameState;
    INSERT INTO gameState VALUES ('W', CASE WHEN two_players THEN TRUE ELSE player_begins END, TRUE);
    INSERT INTO gameState VALUES ('B', CASE WHEN two_players THEN TRUE ELSE NOT player_begins END, FALSE);
END;
/

-- Startet das Spiel
CREATE OR REPLACE PROCEDURE startGame(two_players BOOLEAN, player_begins BOOLEAN) AS
BEGIN
    resetBoard;
    initGameState(two_players, player_begins);
END;
/

-- manage all en passant moves
CREATE OR REPLACE PROCEDURE manageEnPassant(from_square VARCHAR2, to_square VARCHAR2) AS
    from_line INT;
    from_column varchar2(1);
    to_line INT;
    to_column VARCHAR2(1);
    color VARCHAR2(1);
    en_passant_line INT;
    column_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H');
    sql_stmt VARCHAR2(4000);
BEGIN
    from_line := TO_NUMBER(SUBSTR(from_square, 2, 1));
    to_line := TO_NUMBER(SUBSTR(to_square, 2, 1));
    from_column := SUBSTR(from_square, 1, 1);
    to_column := SUBSTR(to_square, 1, 1);

    SELECT gs.COLOR into color FROM gameState gs WHERE hasTurn = TRUE;

    -- remove all en passant flags
    -- Loop through each column (A to H)
    FOR i IN 1..column_names.COUNT LOOP
        -- Construct the SQL to update each column
        sql_stmt := 'UPDATE board SET ' || column_names(i) || ' = '' '' WHERE ' 
                    || column_names(i) || ' IN (''PB'', ''PW'')';

        -- Execute the dynamic SQL
        EXECUTE IMMEDIATE sql_stmt;
    END LOOP;

    -- Commit the changes
    COMMIT;

    IF (color = 'W') THEN
        en_passant_line := 3;
    ELSIF (color = 'B') THEN
        en_passant_line := 6;
    END IF;

    DBMS_OUTPUT.PUT_LINE('from_line: ' || from_line || ' to_line: ' || to_line);

    -- set en passant flag
    IF ABS(from_line - to_line) = 2 THEN
        DBMS_OUTPUT.PUT_LINE('En passant flag set on ' || to_column || en_passant_line);
        EXECUTE IMMEDIATE 'UPDATE board SET ' || to_column || ' = :1 WHERE line = :2'
        USING 'P' || color, en_passant_line;
    END IF;
END;
/


-- Führt einen Spielzug aus
CREATE OR REPLACE PROCEDURE playTurn(from_square VARCHAR2, to_square VARCHAR2) AS
    current_turn CHAR(1);
    is_valid BOOLEAN;
    from_line INT;
    to_line INT;
    from_column CHAR(1);
    to_column CHAR(1);
BEGIN
    if getEndCondition IS NOT NULL THEN
        outputWinningConditionToTerminal;
        return;
    END IF;
    


    from_line := TO_NUMBER(SUBSTR(from_square, 2, 1));
    to_line := TO_NUMBER(SUBSTR(to_square, 2, 1));
    from_column := SUBSTR(from_square, 1, 1);
    to_column := SUBSTR(to_square, 1, 1);

    SELECT color INTO current_turn FROM gameState WHERE hasTurn = TRUE;

    is_valid := canMovePawn(from_square, to_square);

    IF NOT is_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ungültiger Zug!');
    END IF;
    
    -- delete the pawn for the corresponding en passante pawn
    if (getSquare(to_square) = 'PW') then
        EXECUTE IMMEDIATE 'UPDATE board SET ' || to_column || ' = '' '' WHERE line = :1'
        USING to_line + 1;
    elsif (getSquare(to_square) = 'PB') then
        EXECUTE IMMEDIATE 'UPDATE board SET ' || to_column || ' = '' '' WHERE line = :1'
        USING to_line - 1;
        end if;

    EXECUTE IMMEDIATE 'UPDATE board SET ' || to_column || ' = :1 WHERE line = :2'
        USING current_turn, to_line;

    EXECUTE IMMEDIATE 'UPDATE board SET ' || from_column || ' = '' '' WHERE line = :1'
        USING from_line;

    MANAGEENPASSANT(from_square, to_square);

    UPDATE gameState SET hasTurn = NOT hasTurn WHERE color = current_turn;
    UPDATE gameState SET hasTurn = TRUE WHERE color != current_turn;

    if getEndCondition IS NOT NULL THEN
        outputWinningConditionToTerminal;
    END IF;
    
END;
/


CREATE OR REPLACE PROCEDURE outputWinningConditionToTerminal AS
begin
    IF getEndCondition IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(' _______  _______  _______  _______           _______  _______  _______  _        _______ ');
        DBMS_OUTPUT.PUT_LINE('(  ___  )(  ___  )(  ____ \(  ____ \|\     /|(  ____ )(  ___  )(  ____ \( \      (  ____ \');
        DBMS_OUTPUT.PUT_LINE('| (   ) || (   ) || (    \/| (    \/| )   ( || (    )|| (   ) || (    \/| (      | (    \/');
        DBMS_OUTPUT.PUT_LINE('| |   | || (___) || (_____ | |      | (___) || (____)|| (___) || |      | |      | (__    ');
        DBMS_OUTPUT.PUT_LINE('| |   | ||  ___  |(_____  )| |      |  ___  ||     __)|  ___  || |      | |      |  __)   ');
        DBMS_OUTPUT.PUT_LINE('| |   | || (   ) |      ) || |      | (   ) || (\ (   | (   ) || |      | |      | (      ');
        DBMS_OUTPUT.PUT_LINE('| (___) || )   ( |/\____) || (____/\| )   ( || ) \ \__| )   ( || (____/\| (____/\| (____/\');
        DBMS_OUTPUT.PUT_LINE('(_______)|/     \|\_______)(_______/|/     \||/   \__/|/     \|(_______/(_______/(_______/');

        if getEndCondition = 'W' then
            DBMS_OUTPUT.PUT_LINE('#######################################################');
            DBMS_OUTPUT.PUT_LINE(' __     __   __  __   __   ______  ______       __     __   __   __   __   ______   ');
            DBMS_OUTPUT.PUT_LINE('/\ \  _ \ \ /\ \_\ \ /\ \ /\__  _\/\  ___\     /\ \  _ \ \ /\ \ /\ "-.\ \ /\  ___\  ');
            DBMS_OUTPUT.PUT_LINE('\ \ \/ ".\ \\ \  __ \\ \ \\/_/\ \/\ \  __\     \ \ \/ ".\ \\ \ \\ \ \-.  \\ \___  \ ');
            DBMS_OUTPUT.PUT_LINE(' \ \__/".~\_\\ \_\ \_\\ \_\  \ \_\ \ \_____\    \ \__/".~\_\\ \_\\ \_\\"\_\\/\_____\');
            DBMS_OUTPUT.PUT_LINE('  \/_/   \/_/ \/_/\/_/ \/_/   \/_/  \/_____/     \/_/   \/_/ \/_/ \/_/ \/_/ \/_____/');
            DBMS_OUTPUT.PUT_LINE('#######################################################');
        elsif getEndCondition = 'B' then
            DBMS_OUTPUT.PUT_LINE('#######################################################');
            DBMS_OUTPUT.PUT_LINE(' ______   __       ______   ______   __  __       __     __   __   __   __   ______   ');
            DBMS_OUTPUT.PUT_LINE('/\  == \ /\ \     /\  __ \ /\  ___\ /\ \/ /      /\ \  _ \ \ /\ \ /\ "-.\ \ /\  ___\  ');
            DBMS_OUTPUT.PUT_LINE('\ \  __< \ \ \____\ \  __ \\ \ \____\ \  _"-.    \ \ \/ ".\ \\ \ \\ \ \-.  \\ \___  \ ');
            DBMS_OUTPUT.PUT_LINE(' \ \_____\\ \_____\\ \_\ \_\\ \_____\\ \_\ \_\    \ \__/".~\_\\ \_\\ \_\\"\_\\/\_____\');
            DBMS_OUTPUT.PUT_LINE('  \/_____/ \/_____/ \/_/\/_/ \/_____/ \/_/\/_/     \/_/   \/_/ \/_/ \/_/ \/_/ \/_____/');
            DBMS_OUTPUT.PUT_LINE('#######################################################');
        else
            DBMS_OUTPUT.PUT_LINE('#######################################################');
            DBMS_OUTPUT.PUT_LINE(' _____     ______     ______     __     __   '); 
            DBMS_OUTPUT.PUT_LINE('/\  __-.  /\  == \   /\  __ \   /\ \  _ \ \  '); 
            DBMS_OUTPUT.PUT_LINE('\ \ \/\ \ \ \  __<   \ \  __ \  \ \ \/ ".\ \ '); 
            DBMS_OUTPUT.PUT_LINE(' \ \____-  \ \_\ \_\  \ \_\ \_\  \ \__/".~\_\'); 
            DBMS_OUTPUT.PUT_LINE('  \/____/   \/_/ /_/   \/_/\/_/   \/_/   \/_/'); 
            DBMS_OUTPUT.PUT_LINE('#######################################################');
        end if;
    END IF;
end;
/