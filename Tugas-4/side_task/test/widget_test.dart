import 'package:flutter_test/flutter_test.dart';
import 'package:side_task/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PortofolioApp());
    expect(find.byType(PortofolioApp), findsOneWidget);
  });
}
