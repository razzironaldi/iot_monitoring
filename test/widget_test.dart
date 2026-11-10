// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:iot_monitoring/main.dart';

void main() {
  testWidgets('IoT Monitoring dashboard renders and toggles status', (WidgetTester tester) async {
    await tester.pumpWidget(const IotMonitoringApp());

    expect(find.text('IoT Monitoring'), findsOneWidget);
    expect(find.text('30.5°C'), findsWidgets);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('Connected'), findsOneWidget);

    await tester.tap(find.text('Connected'));
    await tester.pump();
    expect(find.text('Disconnected'), findsOneWidget);
  });
}
