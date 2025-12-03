import 'dart:async';

import 'package:sirsak_pop_nasabah/app/app.bottomsheets.dart';
import 'package:sirsak_pop_nasabah/app/app.dialogs.dart';
import 'package:sirsak_pop_nasabah/app/app.locator.dart';
import 'package:sirsak_pop_nasabah/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;

  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void showDialog() {
    unawaited(_dialogService.showCustomDialog<void, void>(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    ),);
  }

  void showBottomSheet() {
    unawaited(_bottomSheetService.showCustomSheet<void, void>(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    ),);
  }
}
