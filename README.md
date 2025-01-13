# 🏰 Bauernschach: A Chess Variant with Pawns Only

**Bauernschach** is a simplified chess variant played exclusively with pawns on an 8x8 chessboard. The goal of this project is to implement the game logic and structure in Oracle Database using SQL and PL/SQL. The implementation handles game initialization, movement, and win conditions while following chess rules for pawn movement, including **en passant** and promotion-like rules. This project is ideal for developers looking to explore database-driven game mechanics.

## Developers
Sven Oberwalder (@Sormy23), Yasin Sahin (@YassinoZoldyck)

---

## 🚀 Features

1. **Database-Driven Gameboard**  
   - `board` table represents the chessboard as an 8x8 grid.
   - Each cell tracks the presence of white pawns (`W`), black pawns (`B`), and special "en passant" states (`PW`, `PB`).

2. **Game State Management**  
   - `gameState` table keeps track of player details, turn order, and whether the game is single-player or multiplayer.

3. **PL/SQL Procedures and Functions**  
   - **`startGame`**: Initializes the game board and state.  
   - **`playTurn`**: Handles pawn movement and turn switching.  
   - **`doesPawnExist`**: Validates the presence of a pawn on a square.  
   - **`canMovePawn`**: Checks if a move is valid based on game rules.  
   - **`getEndCondition`**: Determines if a win or draw condition has been met.

4. **Support for Chess Rules**  
   - En passant moves are implemented.
   - Movement validation ensures adherence to chess pawn rules.

---

## 📂 Project Structure

```plaintext
.
├── sql/
│   ├── create_tables.sql       # SQL scripts to create the database schema
│   ├── procedures.sql          # PL/SQL scripts for procedures
│   ├── functions.sql           # PL/SQL scripts for functions
│   └── setup.sql               # Script to initialize the database
├── README.md                   # Project documentation
```

---

## 📊 Database Schema

### `board` Table
Represents the chessboard as an 8x8 grid.

| Column | Type      | Description                              |
|--------|-----------|------------------------------------------|
| line   | NUMBER(1) | Row number (1 to 8 or 8 to 1 for black). |
| A–H    | VARCHAR2(2) | Column values (`W`, `B`, `PW`, `PB`, or `NULL`). |

### `gameState` Table
Stores the current state of the game.

| Column   | Type      | Description                        |
|----------|-----------|------------------------------------|
| color    | CHAR(1)   | Player color (`W` or `B`).         |
| isPlayer | CHAR(1)   | Whether this is a human player (`Y` or `N`). |
| hasTurn  | CHAR(1)   | Indicates whose turn it is.        |

---

## 🛠️ How to Use

### 1. **Setup the Database**
   - Run the SQL scripts in the following order:
     1. `create_tables.sql`
     2. `procedures.sql`
     3. `functions.sql`
     4. `setup.sql`

### 2. **Start the Game**
   - Use the `startGame` procedure to initialize the game.  
     Example:
     ```sql
     BEGIN
         startGame(TRUE, TRUE); -- Two players, white starts
     END;
     ```

### 3. **Play Moves**
   - Use the `playTurn` procedure to make moves.  
     Example:
     ```sql
     BEGIN
         playTurn('A2', 'A3'); -- Move white pawn from A2 to A3
     END;
     ```

### 4. **Check Win Condition**
   - Use the `getEndCondition` function to see if the game has ended.  
     Example:
     ```sql
     SELECT getEndCondition() FROM dual; -- Returns 'W', 'B', or NULL
     ```

---

## 🔍 Example Gameplay

1. Start the game in single-player mode with the player as white:
   ```sql
   BEGIN
       startGame(FALSE, TRUE);
   END;
   ```

2. Move pawns alternately:
   ```sql
   BEGIN
       playTurn('A2', 'A3'); -- White moves
       playTurn('A7', 'A6'); -- Black moves
   END;
   ```

3. Check if a player has won:
   ```sql
   SELECT getEndCondition() FROM dual;
   ```

---

## 📖 Rules Overview

- Pawns move forward one square or two squares on their first move.
- Pawns capture diagonally.
- En passant and pawn promotion logic are implemented.
- The game ends when:
  - A white pawn reaches row 8 (white wins).
  - A black pawn reaches row 1 (black wins).
  - There are no valid moves left (draw).

---

## ⚡ Technologies Used

- **Oracle SQL**: Database design and schema.
- **PL/SQL**: Game logic and rule enforcement.
- **SQLPlus**: Command-line interface for Oracle DB.

---

## 🤝 Contribution Guidelines

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature-name`.
3. Commit changes: `git commit -m "Add a new feature"`.
4. Push to the branch: `git push origin feature-name`.
5. Submit a pull request.

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
