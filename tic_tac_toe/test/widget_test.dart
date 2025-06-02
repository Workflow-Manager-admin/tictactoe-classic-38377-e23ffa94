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
    // More than 9 due to reset, filter cell buttons
    int gridCellCount = 0;
    final List<ElevatedButton> buttonWidgets =
        tester.widgetList(gridButtons).whereType<ElevatedButton>().toList();

    for (final btn in buttonWidgets) {
      if (btn.child is Text) {
        final label = (btn.child as Text).data ?? "";
        if (label == "" || label == "X" || label == "O") {
          gridCellCount++;
        }
      }
    }
    expect(gridCellCount, equals(9));
  });
}
