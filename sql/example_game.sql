/*
Sven Oberwalder, Yasin Sahin
Pawn Chess
07.01.2025
*/

SET SERVEROUTPUT ON;

-- Start the game: Two players, white begins
exec startGame(two_players => TRUE, player_begins => TRUE);

SELECT * FROM board;

-- Player 1 (White): Move pawn from e2 to e4
exec playTurn(from_square => 'e2', to_square => 'e4');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from d7 to d5
exec playTurn(from_square => 'd7', to_square => 'd5');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e4 to d5 (capture)
exec playTurn(from_square => 'e4', to_square => 'd5');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from e7 to e5
exec playTurn(from_square => 'e7', to_square => 'e5');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e4 to d5 (en passant)
exec playTurn(from_square => 'd5', to_square => 'e6');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from f7 to f6
exec playTurn(from_square => 'f7', to_square => 'f6');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e6 to e7
exec playTurn(from_square => 'e6', to_square => 'e7');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from f6 to f5
exec playTurn(from_square => 'f6', to_square => 'f5');

SELECT * FROM board;

-- Player 1 (White): Move pawn from c6 to d7 (capture)
exec playTurn(from_square => 'e7', to_square => 'e8');

SELECT * FROM board;