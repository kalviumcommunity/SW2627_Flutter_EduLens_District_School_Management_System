import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/app.dart';

void main() {
  testWidgets('EduLensApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EduLensApp());
    await tester.pumpAndSettle();

    // Verify that the initial Login route is rendered.
    expect(find.text('Login'), findsNWidgets(2));
  });
}
