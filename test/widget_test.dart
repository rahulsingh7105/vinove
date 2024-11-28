import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/main.dart'; // Your main app file

void main() {
  testWidgets('Navigate to LocationScreen when location icon is tapped', (WidgetTester tester) async {
    // Build the app (which includes MemberScreen)
    await tester.pumpWidget(MyApp());

    // Find the first member's location icon
    final locationIcon = find.byIcon(Icons.location_on);

    // Verify that the location icon is present
    expect(locationIcon, findsOneWidget);

    // Tap the location icon to navigate
    await tester.tap(locationIcon);
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify that we have navigated to the LocationScreen
    expect(find.text('Location for'), findsOneWidget); // Ensure LocationScreen is displayed
  });
}
