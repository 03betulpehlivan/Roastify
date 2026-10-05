import 'package:ai_roast_battle/cekirdek/is_mantigi/ayarlar_cubiti.dart';
import 'package:ai_roast_battle/ozellikler/kapsayici/sunum/ana_kapsayici_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Bottom navigation smoke', () {
    testWidgets('switches between tab pages', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => AyarlarCubiti(prefs),
            child: const AnaKapsayiciSayfa(
              testSayfalar: [
                Center(child: Text('TAB_HOME')),
                Center(child: Text('TAB_SHOWCASE')),
                Center(child: Text('TAB_HISTORY')),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TAB_HOME'), findsOneWidget);

      await tester.tap(find.text('Onur Tablosu'));
      await tester.pumpAndSettle();
      expect(find.text('TAB_SHOWCASE'), findsOneWidget);

      await tester.tap(find.text('Geçmiş'));
      await tester.pumpAndSettle();
      expect(find.text('TAB_HISTORY'), findsOneWidget);
    });
  });
}
