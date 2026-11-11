import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conociendoalapersona/main.dart';

Future<void> tocar(WidgetTester tester, String texto) async {
  await tester.ensureVisible(find.text(texto));
  await tester.pumpAndSettle();
  await tester.tap(find.text(texto));
  await tester.pumpAndSettle();
}

Future<void> capturar(WidgetTester tester, String nombre, String edad, String sueldo) async {
  await tester.enterText(find.widgetWithText(TextField, 'Nombre completo'), nombre);
  await tester.enterText(find.widgetWithText(TextField, 'Edad'), edad);
  await tester.enterText(find.widgetWithText(TextField, 'Sueldo mensual'), sueldo);
  await tocar(tester, 'Verificar');
}

void main() {
  testWidgets('R1: muestra el título «Conociendo a la persona»', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Conociendo a la persona'), findsWidgets);
  });

  testWidgets('Prueba 1: Ana Torres, 17 años, 8000 → menor de edad y sueldo NO por arriba', (tester) async {
    await tester.pumpWidget(const MyApp());
    await capturar(tester, 'Ana Torres', '17', '8000');
    expect(find.textContaining('Hola, Ana Torres.'), findsWidgets);
    expect(find.textContaining('Eres menor de edad.'), findsWidgets);
    expect(find.textContaining('NO está por arriba'), findsWidgets);
  });

  testWidgets('Prueba 2: edad 18 y sueldo igual al mínimo → mayor de edad, NO por arriba', (tester) async {
    await tester.pumpWidget(const MyApp());
    await capturar(tester, 'Luis Pérez', '18', '9582.47');
    expect(find.textContaining('Eres mayor de edad.'), findsWidgets);
    expect(find.textContaining('NO está por arriba'), findsWidgets);
  });

  testWidgets('Prueba 3: sueldo 9582.48 → SÍ está por arriba del mínimo', (tester) async {
    await tester.pumpWidget(const MyApp());
    await capturar(tester, 'Carla Ruiz', '30', '9582.48');
    expect(find.textContaining('SÍ está por arriba'), findsWidgets);
  });

  testWidgets('R6: el resultado aparece en el diálogo y en la etiqueta', (tester) async {
    await tester.pumpWidget(const MyApp());
    await capturar(tester, 'María López', '45', '25000.50');
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.textContaining('Hola, María López.'), findsOneWidget);
  });

  testWidgets('R9: con datos incompletos muestra el diálogo «Datos incompletos»', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.widgetWithText(TextField, 'Nombre completo'), 'Ana Torres');
    await tocar(tester, 'Verificar');
    expect(find.text('Datos incompletos'), findsOneWidget);
  });

  testWidgets('R7: Limpiar datos borra los campos y la etiqueta', (tester) async {
    await tester.pumpWidget(const MyApp());
    await capturar(tester, 'María López', '45', '25000.50');
    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();
    await tocar(tester, 'Limpiar datos');
    expect(find.textContaining('Hola, María López.'), findsNothing);
    expect(find.text('María López'), findsNothing);
  });
}
