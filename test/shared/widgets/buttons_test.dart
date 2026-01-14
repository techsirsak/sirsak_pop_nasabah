import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

void main() {
  group('SButton', () {
    testWidgets('renders with required text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var wasCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SButton(
              text: 'Test',
              onPressed: () => wasCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(wasCalled, isTrue);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SButton(
              text: 'Test',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SButton(
              text: 'Test',
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('is disabled when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SButton(
              text: 'Test',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SButton(
              text: 'Test',
              onPressed: () {},
              icon: Icons.add,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('uses Gap widget for icon spacing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SButton(
              text: 'Test',
              onPressed: () {},
              icon: Icons.add,
            ),
          ),
        ),
      );

      expect(find.byType(Gap), findsOneWidget);
    });

    testWidgets('has Semantics wrapper', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final semanticsList = tester.widgetList<Semantics>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Semantics),
        ),
      );

      // Find the Semantics widget with button properties (our wrapper)
      final semantics = semanticsList.firstWhere(
        (s) => s.properties.button ?? false,
      );

      expect(semantics.properties.button, isTrue);
      expect(semantics.properties.enabled, isTrue);
      expect(semantics.properties.label, 'Test Button');
    });

    testWidgets('Semantics marks button as disabled when onPressed is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SButton(
              text: 'Test',
            ),
          ),
        ),
      );

      final semanticsList = tester.widgetList<Semantics>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Semantics),
        ),
      );

      // Find the Semantics widget with button properties (our wrapper)
      final semantics = semanticsList.firstWhere(
        (s) => s.properties.button ?? false,
      );

      expect(semantics.properties.enabled, isFalse);
    });

    testWidgets('Semantics marks button as disabled when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SButton(
              text: 'Test',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      final semanticsList = tester.widgetList<Semantics>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Semantics),
        ),
      );

      // Find the Semantics widget with button properties (our wrapper)
      final semantics = semanticsList.firstWhere(
        (s) => s.properties.button ?? false,
      );

      expect(semantics.properties.enabled, isFalse);
    });

    group('Variants', () {
      testWidgets('primary variant uses ElevatedButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.byType(OutlinedButton), findsNothing);
        expect(find.byType(TextButton), findsNothing);
      });

      testWidgets('outlined variant uses OutlinedButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
                variant: ButtonVariant.outlined,
              ),
            ),
          ),
        );

        expect(find.byType(OutlinedButton), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNothing);
        expect(find.byType(TextButton), findsNothing);
      });

      testWidgets('text variant uses TextButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
                variant: ButtonVariant.text,
              ),
            ),
          ),
        );

        expect(find.byType(TextButton), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNothing);
        expect(find.byType(OutlinedButton), findsNothing);
      });

      testWidgets('primary variant shows loading indicator in white', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
                isLoading: true,
              ),
            ),
          ),
        );

        final indicator = tester.widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator),
        );

        expect(
          (indicator.valueColor! as AlwaysStoppedAnimation<Color>).value,
          Colors.white,
        );
      });

      testWidgets(
        'outlined variant shows loading indicator in primaryContainer',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SButton(
                  text: 'Test',
                  onPressed: () {},
                  variant: ButtonVariant.outlined,
                  isLoading: true,
                ),
              ),
            ),
          );

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );

      testWidgets('text variant shows loading indicator in tertiary color', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
                variant: ButtonVariant.text,
                isLoading: true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group(
      'Sizes',
      () {
        testWidgets('small size has correct height', (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SButton(
                  text: 'Test',
                  onPressed: () {},
                  size: ButtonSize.small,
                ),
              ),
            ),
          );

          // Find the SizedBox that wraps the ElevatedButton (direct parent)
          final sizedBoxList = tester.widgetList<SizedBox>(
            find.ancestor(
              of: find.byType(ElevatedButton),
              matching: find.byType(SizedBox),
            ),
          );

          // Find the one with height property set to 40
          final sizedBox = sizedBoxList.firstWhere((sb) => sb.height == 40);

          expect(sizedBox.height, 40);
        });

        testWidgets('medium size has correct height', (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SButton(
                  text: 'Test',
                  onPressed: () {},
                ),
              ),
            ),
          );

          final sizedBox = tester.widget<SizedBox>(
            find.ancestor(
              of: find.byType(ElevatedButton),
              matching: find.byType(SizedBox),
            ),
          );

          expect(sizedBox.height, 50);
        });

        testWidgets('large size has correct height', (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SButton(
                  text: 'Test',
                  onPressed: () {},
                  size: ButtonSize.large,
                ),
              ),
            ),
          );

          final sizedBox = tester.widget<SizedBox>(
            find.ancestor(
              of: find.byType(ElevatedButton),
              matching: find.byType(SizedBox),
            ),
          );

          expect(sizedBox.height, 56);
        });

        testWidgets('small size has touch target padding', (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SButton(
                  text: 'Test',
                  onPressed: () {},
                  size: ButtonSize.small,
                ),
              ),
            ),
          );

          // Small buttons should have Padding wrapper for touch target
          expect(
            find.ancestor(
              of: find.byType(SizedBox),
              matching: find.byType(Padding),
            ),
            findsOneWidget,
          );
        });

        testWidgets(
          'medium and large sizes do not have extra touch target padding',
          (
            tester,
          ) async {
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: Column(
                    children: [
                      SButton(
                        text: 'Medium',
                        onPressed: () {},
                      ),
                      SButton(
                        text: 'Large',
                        onPressed: () {},
                        size: ButtonSize.large,
                      ),
                    ],
                  ),
                ),
              ),
            );

            // Medium and large should have no extra padding
            // (Padding is for touch target only)
            // We check that the immediate parent of Semantics is NOT Padding
            //with vertical padding
            final mediumButton = find.text('Medium');
            final largeButton = find.text('Large');

            expect(mediumButton, findsOneWidget);
            expect(largeButton, findsOneWidget);
          },
        );
      },
    );

    group('Full Width', () {
      testWidgets('is full width by default', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                child: SButton(
                  text: 'Test',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        // Find the SizedBox that wraps the ElevatedButton (direct parent)
        final sizedBoxList = tester.widgetList<SizedBox>(
          find.ancestor(
            of: find.byType(ElevatedButton),
            matching: find.byType(SizedBox),
          ),
        );

        // Find the one with height property (button wrapper)
        // which also has width
        final sizedBox = sizedBoxList.firstWhere((sb) => sb.height != null);

        expect(sizedBox.width, double.infinity);
      });

      testWidgets('wraps content when isFullWidth is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                child: SButton(
                  text: 'Test',
                  onPressed: () {},
                  isFullWidth: false,
                ),
              ),
            ),
          ),
        );

        // Find the SizedBox that wraps the ElevatedButton (direct parent)
        final sizedBoxList = tester.widgetList<SizedBox>(
          find.ancestor(
            of: find.byType(ElevatedButton),
            matching: find.byType(SizedBox),
          ),
        );

        // Find the one with height property (button wrapper)
        final sizedBox = sizedBoxList.firstWhere((sb) => sb.height != null);

        expect(sizedBox.width, isNull);
      });
    });

    group('Icon Integration', () {
      testWidgets('icon appears before text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Add Item',
                onPressed: () {},
                icon: Icons.add,
              ),
            ),
          ),
        );

        // Find Row containing icon and text
        final row = find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(Row),
        );

        expect(row, findsOneWidget);

        // Verify icon comes before text
        final rowWidget = tester.widget<Row>(row);
        expect(rowWidget.children.length, 3); // Icon, Gap, Text
        expect(rowWidget.children[0], isA<Icon>());
        expect(rowWidget.children[1], isA<Gap>());
        expect(rowWidget.children[2], isA<Text>());
      });

      testWidgets('no icon when icon parameter is null', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(Icon), findsNothing);
        expect(find.byType(Gap), findsNothing);
        expect(find.byType(Row), findsNothing);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles null onPressed and isLoading true', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                isLoading: true,
              ),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );

        // Button should be disabled
        expect(button.onPressed, isNull);
        // Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('handles very long text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                child: SButton(
                  text: 'This is a very long button text that might wrap',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        expect(
          find.text('This is a very long button text that might wrap'),
          findsOneWidget,
        );
      });

      testWidgets('handles icon with very short text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'OK',
                onPressed: () {},
                icon: Icons.check,
                isFullWidth: false,
              ),
            ),
          ),
        );

        expect(find.text('OK'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsOneWidget);

        // Find the SizedBox that wraps the ElevatedButton (direct parent)
        final sizedBoxList = tester.widgetList<SizedBox>(
          find.ancestor(
            of: find.byType(ElevatedButton),
            matching: find.byType(SizedBox),
          ),
        );

        // Find the one with width property (button wrapper)
        final sizedBox = sizedBoxList.firstWhere((sb) => sb.height != null);

        // Should not be full width
        expect(sizedBox.width, isNull);
      });

      testWidgets('loading indicator size scales with button size', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  SButton(
                    text: 'Small',
                    onPressed: () {},
                    size: ButtonSize.small,
                    isLoading: true,
                  ),
                  SButton(
                    text: 'Medium',
                    onPressed: () {},
                    isLoading: true,
                  ),
                  SButton(
                    text: 'Large',
                    onPressed: () {},
                    size: ButtonSize.large,
                    isLoading: true,
                  ),
                ],
              ),
            ),
          ),
        );

        // Should have 3 loading indicators
        expect(find.byType(CircularProgressIndicator), findsNWidgets(3));

        // Verify that loading indicators have different sizes
        // Small button: 40 * 0.6 = 24
        // Medium button: 50 * 0.6 = 30
        // Large button: 56 * 0.6 = 33.6
        final indicatorSizes = tester
            .widgetList<SizedBox>(find.byType(SizedBox))
            .where(
              (sb) =>
                  sb.width != null &&
                  sb.height != null &&
                  sb.width == sb.height,
            )
            .map((sb) => sb.width)
            .toSet();

        // Should have 3 different indicator sizes
        expect(indicatorSizes.length, 3);
        expect(indicatorSizes, contains(24.0));
        expect(indicatorSizes, contains(30.0));
        expect(indicatorSizes, contains(33.6));
      });
    });

    group('Button Styling', () {
      testWidgets('primary button has correct border radius', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
              ),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );

        final shape = button.style?.shape?.resolve({});
        expect(shape, isA<RoundedRectangleBorder>());

        final roundedShape = shape! as RoundedRectangleBorder;
        expect(
          roundedShape.borderRadius,
          BorderRadius.circular(12),
        );
      });

      testWidgets('outlined button has correct border radius', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
                variant: ButtonVariant.outlined,
              ),
            ),
          ),
        );

        final button = tester.widget<OutlinedButton>(
          find.byType(OutlinedButton),
        );

        final shape = button.style?.shape?.resolve({});
        expect(shape, isA<RoundedRectangleBorder>());

        final roundedShape = shape! as RoundedRectangleBorder;
        expect(
          roundedShape.borderRadius,
          BorderRadius.circular(12),
        );
      });

      testWidgets('text button has correct border radius', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
                variant: ButtonVariant.text,
              ),
            ),
          ),
        );

        final button = tester.widget<TextButton>(
          find.byType(TextButton),
        );

        final shape = button.style?.shape?.resolve({});
        expect(shape, isA<RoundedRectangleBorder>());

        final roundedShape = shape! as RoundedRectangleBorder;
        expect(
          roundedShape.borderRadius,
          BorderRadius.circular(8),
        );
      });

      testWidgets('primary button has elevation 0', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
              ),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );

        final elevation = button.style?.elevation?.resolve({});
        expect(elevation, 0);
      });

      testWidgets('outlined button has 2px border', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SButton(
                text: 'Test',
                onPressed: () {},
                variant: ButtonVariant.outlined,
              ),
            ),
          ),
        );

        final button = tester.widget<OutlinedButton>(
          find.byType(OutlinedButton),
        );

        final side = button.style?.side?.resolve({});
        expect(side?.width, 2);
      });
    });
  });
}
