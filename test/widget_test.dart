import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/app.dart';

void main() {
  testWidgets('EduLensApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EduLensApp());

    // Verify that the welcome text is displayed.
    expect(find.text('Welcome to EduLens'), findsOneWidget);
  });
}
