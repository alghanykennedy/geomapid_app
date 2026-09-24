import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geomapid_app/core/widgets/feature_popup_card.dart';

void main() {
  testWidgets('FeaturePopupCard displays title, address, and coordinates correctly',
      (WidgetTester tester) async {
    bool closeCalled = false;

    final properties = {
      'NAMA': 'Pantai Parangtritis',
      'ALAMAT': 'Jl. Parangtritis Km 28',
      'KECAMATAN': 'Kretek',
      'KABKOT': 'Bantul',
      'PROVINSI': 'D.I. Yogyakarta',
      'Latitude': -8.025,
      'Longitude': 110.33,
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FeaturePopupCard(
            properties: properties,
            onClose: () {
              closeCalled = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Pantai Parangtritis'), findsOneWidget);

    final richTextFinder = find.byType(RichText);
    expect(richTextFinder, findsWidgets);

    final closeButton = find.byIcon(Icons.close);
    expect(closeButton, findsOneWidget);

    await tester.tap(closeButton);
    expect(closeCalled, isTrue);
  });
}
