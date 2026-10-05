import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ai_roast_battle/ozellikler/giris/sunum/onboarding_sayfasi.dart';
import 'package:ai_roast_battle/l10n/app_localizations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding basic flow', () {
    testWidgets('renders first page and advances with swipe', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('tr'),
          home: OnboardingSayfasi(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('HOS GELDINIZ'), findsOneWidget);
      expect(find.text('SONRAKI'), findsOneWidget);

      await tester.drag(find.byType(PageView), const Offset(-350, 0));
      await tester.pumpAndSettle();

      expect(find.text('JUDGE SECIN'), findsOneWidget);
    });

    testWidgets('reaches last page and shows start button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('tr'),
          home: OnboardingSayfasi(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-350, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-350, 0));
      await tester.pumpAndSettle();

      expect(find.text('ZAFERE ULASIN'), findsOneWidget);
      expect(find.text('BASLAYALIM'), findsOneWidget);
    });
  });
}
