import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medo_e_delirio_app/messaging/messaging.dart';

void main() {
  late StreamController<RemoteMessage> messages;

  setUp(() => messages = StreamController<RemoteMessage>());
  tearDown(() => messages.close());

  Future<void> pumpApp(WidgetTester tester) => tester.pumpWidget(MaterialApp(
        builder: (context, child) =>
            ForegroundMessageListener(messages: messages.stream, child: child!),
        home: const Scaffold(),
      ));

  testWidgets('shows title and body of a foreground notification',
      (tester) async {
    await pumpApp(tester);

    messages.add(const RemoteMessage(
        notification:
            RemoteNotification(title: 'Episódio novo', body: 'Corre lá!')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.text('Episódio novo'), findsOneWidget);
    expect(find.text('Corre lá!'), findsOneWidget);
  });

  testWidgets('ignores data-only messages', (tester) async {
    await pumpApp(tester);

    messages.add(const RemoteMessage(data: {'kind': 'silent'}));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.byType(SnackBar), findsNothing);
  });
}
