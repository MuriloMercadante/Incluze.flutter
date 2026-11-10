import 'package:aether_inclusao/main.dart';
import 'package:aether_inclusao/utils/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Splash leva ao onboarding na primeira abertura', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const IncluzeApp());
    expect(find.text('INCLUZE'), findsOneWidget);

    await tester.pump(AppConstants.duracaoSplash);
    await tester.pumpAndSettle();

    expect(find.text('Não mostrar novamente'), findsOneWidget);
    expect(find.text('Avançar'), findsOneWidget);
  });

  testWidgets('Splash leva à Home quando a introdução já foi vista', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'onboarding_visto': true});

    await tester.pumpWidget(const IncluzeApp());
    await tester.pump(AppConstants.duracaoSplash);
    await tester.pumpAndSettle();

    expect(find.text('Encontre lugares acessíveis de verdade'), findsOneWidget);
    expect(find.text('Buscar locais'), findsOneWidget);
  });

  testWidgets('Onboarding salva "Não mostrar novamente"', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const IncluzeApp());
    await tester.pump(AppConstants.duracaoSplash);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Não mostrar novamente'));
    await tester.pump();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Avançar'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarding_visto'), isTrue);
    expect(find.text('Buscar locais'), findsOneWidget);
  });
}
