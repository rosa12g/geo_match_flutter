import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_match_flutter/main.dart';

void main() {
  testWidgets('GeoMatchApp renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(const GeoMatchApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
