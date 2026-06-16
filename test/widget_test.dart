import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:dmn_controle_financeiro/viewmodels/auth_viewmodel.dart';
import 'package:dmn_controle_financeiro/views/auth/auth_view.dart';

void main() {
  testWidgets('AuthView mostra campos de login', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ],
        child: const MaterialApp(home: AuthView()),
      ),
    );

    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
