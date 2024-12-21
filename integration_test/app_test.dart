import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:journal_app/models/settings.dart';
import 'package:journal_app/pages/home/index.dart';
import 'package:journal_app/pages/settings/backup/firebase/firebase_sync.dart';
import 'package:journal_app/pages/settings/backup/gdrive/gdrive_sync.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockStackRouter extends Mock implements StackRouter {}

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      final mockStackRouter = MockStackRouter();
      when(() => mockStackRouter.pushNamed(any())).thenAnswer((_) async {
        return null;
      });
      // Load app widget.
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SettingsStorageNotifier>(
              create: (context) => SettingsStorageNotifier(),
            ),
            ChangeNotifierProvider<GdriveSync>(
              create: (_) => GdriveSync(),
            ),
            ChangeNotifierProvider<FirebaseSync>(
              create: (_) => FirebaseSync(),
            ),
          ],
          child: MaterialApp(
            title: 'Routing Test',
            home: StackRouterScope(
              controller: mockStackRouter,
              stateHash: 0,
              child: HomeScreen(),
            ),
          ),
        ),
      );

      // Verify the counter starts at 0.
      expect(find.text('Journals'), findsOneWidget);

      // Finds the floating action button to tap on.
      final fab = find.byKey(const ValueKey('New Journal'));

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      // expect(find.text('1'), findsOneWidget);
    });
  });
}
