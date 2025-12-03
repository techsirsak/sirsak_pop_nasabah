import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sirsak_pop_nasabah/app/app.bottomsheets.dart';
import 'package:sirsak_pop_nasabah/app/app.locator.dart';
import 'package:sirsak_pop_nasabah/ui/common/app_strings.dart';
import 'package:sirsak_pop_nasabah/ui/views/home/home_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  HomeViewModel getModel() => HomeViewModel();

  group('HomeViewmodelTest -', () {
    setUp(registerServices);
    tearDown(locator.reset);

    group('incrementCounter -', () {
      test('When called once should return  Counter is: 1', () {
        final model = getModel()..incrementCounter();
        expect(model.counterLabel, 'Counter is: 1');
      });
    });

    group('showBottomSheet -', () {
      test(
        'When called, should show custom bottom sheet using notice variant',
        () {
          final bottomSheetService =
              getAndRegisterBottomSheetService<dynamic>();

          getModel().showBottomSheet();
          verify(
            bottomSheetService.showCustomSheet<void, void>(
              variant: BottomSheetType.notice,
              title: ksHomeBottomSheetTitle,
              description: ksHomeBottomSheetDescription,
            ),
          );
        },
      );
    });
  });
}
