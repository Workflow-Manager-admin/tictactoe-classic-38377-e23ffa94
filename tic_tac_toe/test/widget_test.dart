import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/main.dart';

void main() {
  testWidgets('TicTacToe Classic app renders grid and UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Check for presence of app bar title
    expect(find.text('TicTacToe Classic'), findsOneWidget);

    // Check that the turn label is present (either X or O)
    final turnTextFinder = find.textContaining('Player');
    expect(turnTextFinder, findsWidgets);

    // Reset button present
    expect(find.widgetWithIcon(ElevatedButton, Icons.refresh), findsWidgets);

    // There should be 9 grid buttons (cells)
    final gridButtons = find.byType(ElevatedButton);
    expect(gridButtons, findsWidgets); // More than 9 due to reset
    // But at least 9 cell buttons for grid
    int gridCellCount = 0;
    await tester.widgetList(gridButtons).forEach((element) {
      if (element is ElevatedButton &&
          (element.child is Text &&
              ((element.child as Text).data == "" ||
                  (element.child as Text).data == "X" ||
                  (element.child as Text).data == "O"))) {
        gridCellCount++;
      }
    });
    expect(gridCellCount, equals(9));
  });
}
