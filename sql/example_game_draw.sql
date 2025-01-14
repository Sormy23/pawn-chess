/*
Yasin Sahin, Sven Oberwalder
Pawn Chess
13.01.2025
*/

SET SERVEROUTPUT ON;

-- Start the game: Two players, white begins
exec startGame(two_players => TRUE, player_begins => TRUE);

SELECT * FROM board;

-- Player 1 (White): Move pawn from e2 to e4
exec playTurn(from_square => 'a2', to_square => 'a4');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from d7 to d5
exec playTurn(from_square => 'b7', to_square => 'b5');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e4 to d5 (capture)
exec playTurn(from_square => 'c2', to_square => 'c4');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from e7 to e5
exec playTurn(from_square => 'd7', to_square => 'd5');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e4 to d5 (en passant)
exec playTurn(from_square => 'e2', to_square => 'e4');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from f7 to f6
exec playTurn(from_square => 'f7', to_square => 'f5');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e6 to e7
exec playTurn(from_square => 'g2', to_square => 'g4');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from f6 to f5
exec playTurn(from_square => 'h7', to_square => 'h5');

SELECT * FROM board;

-- Player 1 (White): Move pawn from c6 to d7 (capture)
exec playTurn(from_square => 'a4', to_square => 'a5');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from d7 to d5
exec playTurn(from_square => 'b5', to_square => 'b4');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e4 to d5 (capture)
exec playTurn(from_square => 'c4', to_square => 'c5');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from e7 to e5
exec playTurn(from_square => 'd5', to_square => 'd4');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e4 to d5 (en passant)
exec playTurn(from_square => 'e4', to_square => 'e5');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from f7 to f6
exec playTurn(from_square => 'f5', to_square => 'f4');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e6 to e7
exec playTurn(from_square => 'g4', to_square => 'g5');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from f6 to f5
exec playTurn(from_square => 'h5', to_square => 'h4');

SELECT * FROM board;

-- Player 1 (White): Move pawn
exec playTurn(from_square => 'a5', to_square => 'a6');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from d7 to d5
exec playTurn(from_square => 'b4', to_square => 'b3');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e4 to d5 (capture)
exec playTurn(from_square => 'c5', to_square => 'c6');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from e7 to e5
exec playTurn(from_square => 'd4', to_square => 'd3');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e4 to d5 (en passant)
exec playTurn(from_square => 'e5', to_square => 'e6');

SELECT * FROM board;

-- Player 2 (Black): Move pawn from f7 to f6
exec playTurn(from_square => 'f4', to_square => 'f3');

SELECT * FROM board;

-- Player 1 (White): Move pawn from e6 to e7
exec playTurn(from_square => 'g5', to_square => 'g6');

SELECT * FROM board;

-- Player 2 (Black): DRAW
exec playTurn(from_square => 'h4', to_square => 'h3');

SELECT * FROM board;