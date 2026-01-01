import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reson/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: ResonApp(),
      ),
    );

    // Verify that the title 'Reson' is present in the AppBar.
    // Note: Since 'Reson' is a text in AppBar title, find.text should find it.
    expect(find.text('Reson'), findsOneWidget);

    // Verify that tabs are present.
    expect(find.text('Artists'), findsAtLeastNWidgets(1));
    expect(find.text('Albums'), findsAtLeastNWidgets(1));
    
    // Verify that the "Now Playing" button is present.
    expect(find.text('Now Playing'), findsOneWidget);
  });
}