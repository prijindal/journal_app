import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      RouteType.adaptive(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [
        /// routes go here
        AutoRoute(
          initial: true,
          path: "/home",
          page: HomeRoute.page,
        ),
        AutoRoute(
          path: "/search",
          page: SearchRoute.page,
        ),
        CustomRoute<void>(
          path: "/details",
          page: DetailsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute<void>(
          path: "/newjournal",
          page: NewEntryRoute.page,
          transitionsBuilder: TransitionsBuilders.slideBottom,
        ),
        CustomRoute<void>(
          path: "/editjournal/:entryId",
          page: EditEntryRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute<void>(
          path: "/settings",
          page: SettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/settings/backup",
          page: BackupSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/settings/help",
          page: HelpSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/settings/security",
          page: SecuritySettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/settings/styling",
          page: StylingSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/firebase/backup",
          page: FirebaseBackupRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        AutoRoute(
          path: "/firebase/login",
          page: FirebaseLoginRoute.page,
        ),
        AutoRoute(
          path: "/firebase/profile",
          page: FirebaseProfileRoute.page,
        ),
        CustomRoute<void>(
          path: "/gdrive/backup",
          page: GDriveBackupRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
      ];
}
