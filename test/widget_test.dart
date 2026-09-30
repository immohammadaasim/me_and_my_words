// =====================================================================
// ===>> BLOCK DART 2: Automated Unit Testing Configuration <<===
// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:me_and_my_words/main.dart';

// ---------------------------------------------------------------------
// --- Function#1 BLOCK DART 2A: Main App Initialization Test ---
// ---------------------------------------------------------------------
void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MeAndMyWordsApp());

    // Verify that the app builds without crashing
    expect(find.byType(MeAndMyWordsApp), findsOneWidget);
  });
}
// ---------------------------------------------------------------------
// --- Function#1 END OF BLOCK DART 2A: file : test/widget_test.dart ---
// ---------------------------------------------------------------------

// =====================================================================
// ===>> END OF BLOCK DART 2 file : test/widget_test.dart <<===
// =====================================================================