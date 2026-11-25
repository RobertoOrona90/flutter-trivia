import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/ejemplos/selector_edad_demo.dart';

void main() {
  test('rangos de edad a nivel', () {
    expect(Nivel.porEdad(4), Nivel.inicial);
    expect(Nivel.porEdad(6), Nivel.inicial);
    expect(Nivel.porEdad(7), Nivel.explorador);
    expect(Nivel.porEdad(10), Nivel.explorador);
    expect(Nivel.porEdad(11), Nivel.aventurero);
    expect(Nivel.porEdad(14), Nivel.aventurero);
    expect(Nivel.porEdad(15), Nivel.experto);
    expect(Nivel.porEdad(18), Nivel.experto);
  });

  testWidgets('elegir edad en la ruleta cambia el nivel', (tester) async {
    await tester.pumpWidget(const SelectorEdadDemoApp());

    // Estado inicial y ayuda de primera vez.
    expect(find.text('8 años'), findsOneWidget);
    expect(find.text('Nivel Explorador'), findsWidgets);
    expect(
        find.textContaining('Toca aquí para cambiar la edad'), findsOneWidget);

    // Abrir la hoja: la ayuda desaparece.
    await tester.tap(find.byType(PildoraEdad));
    await tester.pumpAndSettle();
    expect(find.text('¿Cuántos años tienes?'), findsOneWidget);
    expect(find.textContaining('Toca aquí para cambiar la edad'), findsNothing);

    // Girar la ruleta 4 posiciones: 8 -> 12 años (Aventurero).
    await tester.drag(find.text('8 años').last, const Offset(0, -160));
    await tester.pumpAndSettle();
    expect(find.text('Listo: 12 años'), findsOneWidget);
    expect(find.text('Nivel Aventurero'), findsOneWidget);

    await tester.tap(find.text('Listo: 12 años'));
    await tester.pumpAndSettle();

    expect(find.text('12 años'), findsOneWidget);
    expect(find.text('Nivel Aventurero'), findsWidgets);
  });
}
