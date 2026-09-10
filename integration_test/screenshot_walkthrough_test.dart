import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eClassify/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Agrodisha Automated App Store Screenshots Capture',
      (WidgetTester tester) async {
    // 1. Launch the Agrodisha app
    app.main();

    // Allow splash screen, Firebase, and initial network calls to settle
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Dismiss any Onboarding screens (tap Next or Skip)
    for (int i = 0; i < 5; i++) {
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

    // Allow Home Screen and its categories/banners to fully render
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // SCREENSHOT 1: Home Screen (Categories & Search & Banner)
    print(">>> CAPTURE_SCREENSHOT: 01_Home_Marketplace");
    await tester.pump(const Duration(seconds: 3));

    // Scroll down on Home feed to showcase listings
    try {
      final scrollables = find.byType(Scrollable);
      if (scrollables.evaluate().isNotEmpty) {
        await tester.drag(scrollables.first, const Offset(0, -320));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    } catch (_) {}

    // SCREENSHOT 2: Featured Classified Listings
    print(">>> CAPTURE_SCREENSHOT: 02_Featured_Listings");
    await tester.pump(const Duration(seconds: 3));

    // Tap on an item card to open Item Details
    bool openedDetails = false;
    try {
      final inkWells = find.byType(InkWell);
      for (final candidate in inkWells.evaluate()) {
        final box = candidate.renderObject as RenderBox?;
        if (box != null && box.size.height > 120 && box.size.width > 120) {
          await tester.tap(find.byWidget(candidate.widget));
          await tester.pumpAndSettle(const Duration(seconds: 4));
          openedDetails = true;
          break;
        }
      }
    } catch (_) {}

    if (openedDetails) {
      // SCREENSHOT 3: Item Details Screen
      print(">>> CAPTURE_SCREENSHOT: 03_Item_Details");
      await tester.pump(const Duration(seconds: 3));

      // Scroll down item details to show seller info and specs
      try {
        final itemScrollables = find.byType(Scrollable);
        if (itemScrollables.evaluate().isNotEmpty) {
          await tester.drag(itemScrollables.first, const Offset(0, -350));
          await tester.pumpAndSettle(const Duration(seconds: 2));
          print(">>> CAPTURE_SCREENSHOT: 03B_Item_Seller_Details");
          await tester.pump(const Duration(seconds: 2));
        }
      } catch (_) {}

      // Go back to Home screen
      try {
        final backIos = find.byIcon(Icons.arrow_back_ios);
        final backNormal = find.byIcon(Icons.arrow_back);
        if (backIos.evaluate().isNotEmpty) {
          await tester.tap(backIos.first);
        } else if (backNormal.evaluate().isNotEmpty) {
          await tester.tap(backNormal.first);
        }
        await tester.pumpAndSettle(const Duration(seconds: 2));
      } catch (_) {}
    }

    // SCREENSHOT 4: Chat Tab
    try {
      final chatTab = find.text("Chat");
      final chatIcon = find.byIcon(Icons.chat_bubble_outline);
      if (chatTab.evaluate().isNotEmpty) {
        await tester.tap(chatTab.first);
      } else if (chatIcon.evaluate().isNotEmpty) {
        await tester.tap(chatIcon.first);
      }
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print(">>> CAPTURE_SCREENSHOT: 04_Chat_Messages");
      await tester.pump(const Duration(seconds: 3));
    } catch (_) {}

    // SCREENSHOT 5: Profile Tab
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
      print(">>> CAPTURE_SCREENSHOT: 05_Profile_Account");
      await tester.pump(const Duration(seconds: 3));

      // Scroll profile down to show settings / subscriptions
      final profileScroll = find.byType(Scrollable);
      if (profileScroll.evaluate().isNotEmpty) {
        await tester.drag(profileScroll.last, const Offset(0, -350));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        print(">>> CAPTURE_SCREENSHOT: 06_Profile_Settings");
        await tester.pump(const Duration(seconds: 2));
      }
    } catch (_) {}

    await tester.pump(const Duration(seconds: 2));
  });
}
