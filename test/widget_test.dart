import 'package:flutter_test/flutter_test.dart';
import 'package:barril_app/main.dart';

void main() {
  testWidgets('App inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const BarrilApp());
    expect(find.text('Barril App lista'), findsOneWidget);
  });
}
