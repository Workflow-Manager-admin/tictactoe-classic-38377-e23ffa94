import 'package:flutter/material.dart';

// PUBLIC_INTERFACE
void main() {
  /// Entry point for the TicTacToe Classic Flutter App.
  runApp(const TicTacToeApp());
}

/// The root widget for the TicTacToe Classic application.
class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom light theme using the requested colors
    final ThemeData theme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF1976D2),         // primary blue
        secondary: const Color(0xFFFFFFFF),       // secondary white
        tertiary: const Color(0xFFFF9800),        // accent orange
      ),
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color(0xFF1976D2),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Color(0xFF1976D2),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.black87,
          fontSize: 18,
        ),
        bodyMedium: TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800), // Accent
          foregroundColor: Colors.white,
          minimumSize: const Size(120, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TicTacToe Classic',
      theme: theme,
      home: const TicTacToeHomePage(),
    );
  }
}

/// Enum describing the state of each TicTacToe cell.
enum PlayerSymbol { X, O, none }

/// The main game page for the TicTacToe Classic game.
class TicTacToeHomePage extends StatefulWidget {
  const TicTacToeHomePage({super.key});
  @override
  State<TicTacToeHomePage> createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  static const int gridSize = 3;

  // Represents the TicTacToe 3x3 board; PlayerSymbol.none for empty
  late List<List<PlayerSymbol>> _board;

  // Tracks which player's turn it is
  late PlayerSymbol _currentPlayer;

  // Game status
  String _statusMessage = "";
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  // PUBLIC_INTERFACE
  void _resetGame() {
    /// Resets the board and player turn
    setState(() {
      _board = List.generate(
        gridSize,
        (_) => List.generate(gridSize, (_) => PlayerSymbol.none),
      );
      _currentPlayer = PlayerSymbol.X;
      _statusMessage = "Player X's turn";
      _gameOver = false;
    });
  }

  // PUBLIC_INTERFACE
  void _handleTap(int i, int j) {
    /// Handles a tap on a cell at (i, j)
    if (_gameOver || _board[i][j] != PlayerSymbol.none) return;

    setState(() {
      _board[i][j] = _currentPlayer;
      if (_checkWin(_currentPlayer)) {
        _statusMessage =
            "Player ${_playerSymbolToString(_currentPlayer)} wins!";
        _gameOver = true;
      } else if (_checkDraw()) {
        _statusMessage = "It's a draw!";
        _gameOver = true;
      } else {
        _currentPlayer =
            _currentPlayer == PlayerSymbol.X ? PlayerSymbol.O : PlayerSymbol.X;
        _statusMessage =
            "Player ${_playerSymbolToString(_currentPlayer)}'s turn";
      }
    });
  }

  // PUBLIC_INTERFACE
  bool _checkWin(PlayerSymbol player) {
    /// Checks if the given player has won the game.
    // Check rows and columns
    for (int i = 0; i < gridSize; i++) {
      if (_board[i].every((cell) => cell == player)) {
        return true;
      }
      if (List.generate(gridSize, (j) => _board[j][i])
          .every((cell) => cell == player)) {
        return true;
      }
    }
    // Check diagonals
    if (List.generate(gridSize, (idx) => _board[idx][idx])
        .every((cell) => cell == player)) {
      return true;
    }
    if (List.generate(gridSize, (idx) => _board[idx][gridSize - 1 - idx])
        .every((cell) => cell == player)) {
      return true;
    }
    return false;
  }

  // PUBLIC_INTERFACE
  bool _checkDraw() {
    /// Checks if the board is full and no winner (draw).
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (_board[i][j] == PlayerSymbol.none) {
          return false;
        }
      }
    }
    // If board is full and there's no win, it's a draw
    return !_checkWin(PlayerSymbol.X) && !_checkWin(PlayerSymbol.O);
  }

  // PUBLIC_INTERFACE
  String _playerSymbolToString(PlayerSymbol player) {
    /// Converts a PlayerSymbol to its display string.
    switch (player) {
      case PlayerSymbol.X:
        return "X";
      case PlayerSymbol.O:
        return "O";
      case PlayerSymbol.none:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.tertiary;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final double cellSize = MediaQuery.of(context).size.width / 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TicTacToe Classic'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Current player's turn
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _gameOver
                      ? "Game Over"
                      : "Turn: Player ${_playerSymbolToString(_currentPlayer)}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: accentColor,
                      ),
                ),
              ),
              // 3x3 Grid Board
              Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                  border: Border.all(color: primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withAlpha(10), // Roughly 0.04 opacity
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(gridSize, (row) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(gridSize, (col) {
                        final symbol = _board[row][col];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: cellSize,
                            height: cellSize,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    symbol == PlayerSymbol.none
                                        ? secondaryColor
                                        : (symbol == PlayerSymbol.X
                                            ? primaryColor
                                            : accentColor),
                                foregroundColor:
                                    symbol == PlayerSymbol.O
                                        ? primaryColor
                                        : accentColor,
                                side: BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _gameOver || symbol != PlayerSymbol.none
                                  ? null
                                  : () => _handleTap(row, col),
                              child: Text(
                                _playerSymbolToString(symbol),
                                style: TextStyle(
                                  fontSize: 48,
                                  color: symbol == PlayerSymbol.none
                                      ? Colors.black54
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
              // Status and Reset below grid
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 20.0),
                child: Column(
                  children: [
                    Text(
                      _statusMessage,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                _gameOver ? accentColor : primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset Game"),
                      onPressed: _resetGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
