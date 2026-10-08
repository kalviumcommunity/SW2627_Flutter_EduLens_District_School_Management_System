import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/app.dart';

void main() {
  testWidgets('EduLensApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EduLensApp());
    await tester.pumpAndSettle();

    // Verify that the initial LoginScreen is rendered
    expect(find.text('EduLens'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
