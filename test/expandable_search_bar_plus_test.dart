import 'package:expandable_search_bar_plus/expandable_search_bar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpandableSearchBarPlus', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('initial width is collapsed (only icon visible)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ExpandableSearchBarPlus(controller: controller),
            ),
          ),
        ),
      );

      // Measure width
      final double width = tester
          .getSize(find.byType(AnimatedContainer).first)
          .width;
      expect(width, closeTo(45, 0.5)); // default iconSize = 45
    });

    testWidgets('expands when tapped', (WidgetTester tester) async {
      bool? expanded;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ExpandableSearchBarPlus(
                controller: controller,
                onTap: (v) => expanded = v,
              ),
            ),
          ),
        ),
      );

      final double initialWidth = tester
          .getSize(find.byType(AnimatedContainer).first)
          .width;

      // Tap to expand
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      final double expandedWidth = tester
          .getSize(find.byType(AnimatedContainer).first)
          .width;

      expect(expandedWidth, greaterThan(initialWidth));
      expect(expanded, isTrue);
    });

    testWidgets('collapses when tapped again', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ExpandableSearchBarPlus(controller: controller),
            ),
          ),
        ),
      );

      // Expand
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      final double expandedWidth = tester
          .getSize(find.byType(AnimatedContainer).first)
          .width;

      // Collapse
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      final double collapsedWidth = tester
          .getSize(find.byType(AnimatedContainer).first)
          .width;

      expect(collapsedWidth, lessThan(expandedWidth));
    });

    testWidgets('calls onChanged when typing', (WidgetTester tester) async {
      String? value;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableSearchBarPlus(
              controller: controller,
              onChanged: (v) => value = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();

      expect(value, 'hello');
    });

    testWidgets('collapses when losing focus and text is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ExpandableSearchBarPlus(controller: controller)),
        ),
      );

      // Expand
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Lose focus
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      final double collapsedWidth = tester
          .getSize(find.byType(AnimatedContainer).first)
          .width;
      expect(collapsedWidth, closeTo(45, 0.5));
    });
  });
}
