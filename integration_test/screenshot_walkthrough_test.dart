import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eClassify/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Agrodisha App Store Screenshots - Guest Mode',
      (WidgetTester tester) async {
    // 1. Launch the app
    app.main();

    // Wait generously for splash, Firebase init, network calls
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // 2. Handle Onboarding - tap Skip or Next repeatedly
    for (int i = 0; i < 6; i++) {
      try {
        final skipFinder = find.text("Skip");
        if (skipFinder.evaluate().isNotEmpty) {
          await tester.tap(skipFinder.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          break;
        }
        final nextKey = find.byKey(const ValueKey("next_screen"));
        if (nextKey.evaluate().isNotEmpty) {
          await tester.tap(nextKey.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
      } catch (_) {}
    }

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 3. On Login screen - tap "Skip" to enter as guest
    for (int i = 0; i < 3; i++) {
      try {
        final skipTexts = find.text("Skip");
        final skipBtn = find.textContaining("skip");
        if (skipTexts.evaluate().isNotEmpty) {
          await tester.tap(skipTexts.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));
          break;
        } else if (skipBtn.evaluate().isNotEmpty) {
          await tester.tap(skipBtn.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));
          break;
        }
      } catch (_) {}
      await tester.pump(const Duration(seconds: 1));
    }

    // 4. Handle Location Permission screen if shown
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    try {
      // Look for any "Allow" or "Continue" or "Skip" on location screen
      for (final label in ["Skip", "Allow", "Continue", "Not Now", "Later"]) {
        final finder = find.text(label);
        if (finder.evaluate().isNotEmpty) {
          await tester.tap(finder.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          break;
        }
      }
    } catch (_) {}

    // 5. Wait for Home screen to fully load (categories, banners, listings)
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // === SCREENSHOT 1: HOME SCREEN ===
    print(">>> SCREENSHOT_READY: 01_Home_Marketplace");
    // Hold for timed capture
    await tester.pump(const Duration(seconds: 8));

    // 6. Scroll down to show Featured Listings
    try {
      final scrollables = find.byType(Scrollable);
      if (scrollables.evaluate().isNotEmpty) {
        await tester.drag(scrollables.first, const Offset(0, -350));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    } catch (_) {}

    // === SCREENSHOT 2: FEATURED LISTINGS ===
    print(">>> SCREENSHOT_READY: 02_Featured_Listings");
    await tester.pump(const Duration(seconds: 8));

    // 7. Tap an item card to open Item Details
    bool openedDetails = false;
    try {
      final inkWells = find.byType(InkWell);
      for (final candidate in inkWells.evaluate()) {
        final box = candidate.renderObject as RenderBox?;
        if (box != null && box.size.height > 120 && box.size.width > 120) {
          await tester.tap(find.byWidget(candidate.widget));
          await tester.pumpAndSettle(const Duration(seconds: 5));
          openedDetails = true;
          break;
        }
      }
    } catch (_) {}

    if (openedDetails) {
      // === SCREENSHOT 3: ITEM DETAILS ===
      print(">>> SCREENSHOT_READY: 03_Item_Details");
      await tester.pump(const Duration(seconds: 8));

      // Scroll to show seller info
      try {
        final scrollables = find.byType(Scrollable);
        if (scrollables.evaluate().isNotEmpty) {
          await tester.drag(scrollables.first, const Offset(0, -350));
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }
      } catch (_) {}

      print(">>> SCREENSHOT_READY: 04_Seller_Info");
      await tester.pump(const Duration(seconds: 8));

      // Go back
      try {
        final back = find.byIcon(Icons.arrow_back_ios);
        final backNormal = find.byIcon(Icons.arrow_back);
        if (back.evaluate().isNotEmpty) {
          await tester.tap(back.first);
        } else if (backNormal.evaluate().isNotEmpty) {
          await tester.tap(backNormal.first);
        }
        await tester.pumpAndSettle(const Duration(seconds: 3));
      } catch (_) {}
    }

    // 8. Scroll home back to top
    try {
      final scrollables = find.byType(Scrollable);
      if (scrollables.evaluate().isNotEmpty) {
        await tester.drag(scrollables.first, const Offset(0, 500));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    } catch (_) {}

    // === SCREENSHOT 5: HOME AFTER BROWSING ===
    print(">>> SCREENSHOT_READY: 05_Home_Categories");
    await tester.pump(const Duration(seconds: 8));

    // 9. Navigate to Profile/Account tab (last tab)
    try {
      // Try bottom nav items - Profile is usually last
      final bottomNavItems = find.byType(InkWell);
      if (bottomNavItems.evaluate().isNotEmpty) {
        await tester.tap(bottomNavItems.last);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    } catch (_) {}

    // === SCREENSHOT 6: PROFILE / ACCOUNT ===
    print(">>> SCREENSHOT_READY: 06_Profile_Account");
    await tester.pump(const Duration(seconds: 8));

    // Final hold
    await tester.pump(const Duration(seconds: 3));
    print(">>> ALL_SCREENSHOTS_DONE");
  });
}
