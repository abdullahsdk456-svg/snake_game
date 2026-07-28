import 'package:flutter_test/flutter_test.dart';
import 'package:snake_game/app.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const NeonSynapseApp());
    expect(find.text('NEON_SYNAPSE_v1.0'), findsWidgets);
  });
}
