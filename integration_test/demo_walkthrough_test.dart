import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eClassify/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Agrodisha Complete User Flow for Apple Review',
      (WidgetTester tester) async {
    // 1. Launch the Agrodisha app
    app.main();

    // Allow splash screen, Firebase, and initial network calls to settle
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Handle any Onboarding screens (tap Next/Skip if present)
    for (int i = 0; i < 4; i++) {
      final nextKey = find.byKey(const ValueKey("next_screen"));
      if (nextKey.evaluate().isNotEmpty) {
        await tester.tap(nextKey.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }
      final skipFinder = find.text("Skip");
      if (skipFinder.evaluate().isNotEmpty) {
        await tester.tap(skipFinder.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }
    }

    // Give time on Home Screen so reviewer sees banner and categories
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Scroll smoothly down and up on Home feed to showcase listings
    try {
      final scrollables = find.byType(Scrollable);
      if (scrollables.evaluate().isNotEmpty) {
        await tester.drag(scrollables.first, const Offset(0, -350));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await tester.drag(scrollables.first, const Offset(0, -350));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await tester.drag(scrollables.first, const Offset(0, 400));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    } catch (_) {}

    // Tap on an item card to show Item Details & Reporting functionality
    try {
      final inkWells = find.byType(InkWell);
      for (final candidate in inkWells.evaluate()) {
        final box = candidate.renderObject as RenderBox?;
        if (box != null && box.size.height > 120 && box.size.width > 120) {
          await tester.tap(find.byWidget(candidate.widget));
          await tester.pumpAndSettle(const Duration(seconds: 4));
          break;
        }
      }

      // Scroll down item details to show map & seller
      final itemScrollables = find.byType(Scrollable);
      if (itemScrollables.evaluate().isNotEmpty) {
        await tester.drag(itemScrollables.first, const Offset(0, -300));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Show more options (reporting / blocking)
      final moreIcon = find.byIcon(Icons.more_vert);
      if (moreIcon.evaluate().isNotEmpty) {
        await tester.tap(moreIcon.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        // Dismiss
        await tester.tapAt(const Offset(50, 100));
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }

      // Go back to Home
      final backIos = find.byIcon(Icons.arrow_back_ios);
      final backNormal = find.byIcon(Icons.arrow_back);
      if (backIos.evaluate().isNotEmpty) {
        await tester.tap(backIos.first);
      } else if (backNormal.evaluate().isNotEmpty) {
        await tester.tap(backNormal.first);
      }
      await tester.pumpAndSettle(const Duration(seconds: 2));
    } catch (_) {}

    // Navigate to Chat screen
    try {
      final chatTab = find.text("Chat");
      if (chatTab.evaluate().isNotEmpty) {
        await tester.tap(chatTab.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    } catch (_) {}

    // Navigate to Profile screen to show Account Deletion option
    try {
      final profileTab = find.text("Profile");
      if (profileTab.evaluate().isNotEmpty) {
        await tester.tap(profileTab.first);
      } else {
        final bottomNavItems = find.byType(InkWell);
        if (bottomNavItems.evaluate().isNotEmpty) {
          await tester.tap(bottomNavItems.last);
        }
      }
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Scroll profile down to display Delete Account button clearly
      final profileScroll = find.byType(Scrollable);
      if (profileScroll.evaluate().isNotEmpty) {
        await tester.drag(profileScroll.last, const Offset(0, -450));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await tester.drag(profileScroll.last, const Offset(0, -300));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    } catch (_) {}

    // Final hold on screen before finishing recording
    await tester.pump(const Duration(seconds: 4));
  });
}
