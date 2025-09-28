import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giant_shelf_app/main.dart'; // package name matches pubspec.yaml

void main() {
  testWidgets('App loads and shows main page', (WidgetTester tester) async {
    await tester.pumpWidget(const ShelfClockApp());

    expect(find.text('Shelf Lights (Main)'), findsOneWidget);
    expect(find.textContaining('Tap a segment'), findsOneWidget);
  });

  testWidgets('Tapping a bar opens the editor sheet', (WidgetTester tester) async {
    await tester.pumpWidget(const ShelfClockApp());
    await tester.pumpAndSettle();

    final firstBar = find.byType(InkWell).first;
    await tester.tap(firstBar);
    await tester.pumpAndSettle();

    expect(find.textContaining('Edit '), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Edit '), findsNothing);
  });
}
