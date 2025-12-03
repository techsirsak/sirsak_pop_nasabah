import 'package:sirsak_pop_nasabah/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:sirsak_pop_nasabah/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:sirsak_pop_nasabah/ui/views/home/home_view.dart';
import 'package:sirsak_pop_nasabah/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton<BottomSheetService>(classType: BottomSheetService),
    LazySingleton<DialogService>(classType: DialogService),
    LazySingleton<NavigationService>(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
