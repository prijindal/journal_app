// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:journal_app/pages/details.dart' as _i2;
import 'package:journal_app/pages/home.dart' as _i5;
import 'package:journal_app/pages/login.dart' as _i6;
import 'package:journal_app/pages/newentry.dart' as _i3;
import 'package:journal_app/pages/profile.dart' as _i11;
import 'package:journal_app/pages/search.dart' as _i7;
import 'package:journal_app/pages/settings/backup.dart' as _i1;
import 'package:journal_app/pages/settings/help.dart' as _i4;
import 'package:journal_app/pages/settings/index.dart' as _i9;
import 'package:journal_app/pages/settings/security.dart' as _i8;
import 'package:journal_app/pages/settings/styling.dart' as _i10;

/// generated route for
/// [_i1.BackupSettingsScreen]
class BackupSettingsRoute extends _i12.PageRouteInfo<void> {
  const BackupSettingsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          BackupSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'BackupSettingsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i1.BackupSettingsScreen();
    },
  );
}

/// generated route for
/// [_i2.DetailsScreen]
class DetailsRoute extends _i12.PageRouteInfo<DetailsRouteArgs> {
  DetailsRoute({
    _i13.Key? key,
    bool showHidden = false,
    String? entryId,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          DetailsRoute.name,
          args: DetailsRouteArgs(
            key: key,
            showHidden: showHidden,
            entryId: entryId,
          ),
          rawQueryParams: {
            'showHidden': showHidden,
            'entryId': entryId,
          },
          initialChildren: children,
        );

  static const String name = 'DetailsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<DetailsRouteArgs>(
          orElse: () => DetailsRouteArgs(
                showHidden: queryParams.getBool(
                  'showHidden',
                  false,
                ),
                entryId: queryParams.optString('entryId'),
              ));
      return _i2.DetailsScreen(
        key: args.key,
        showHidden: args.showHidden,
        entryId: args.entryId,
      );
    },
  );
}

class DetailsRouteArgs {
  const DetailsRouteArgs({
    this.key,
    this.showHidden = false,
    this.entryId,
  });

  final _i13.Key? key;

  final bool showHidden;

  final String? entryId;

  @override
  String toString() {
    return 'DetailsRouteArgs{key: $key, showHidden: $showHidden, entryId: $entryId}';
  }
}

/// generated route for
/// [_i3.EditEntryScreen]
class EditEntryRoute extends _i12.PageRouteInfo<EditEntryRouteArgs> {
  EditEntryRoute({
    _i13.Key? key,
    required String entryId,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          EditEntryRoute.name,
          args: EditEntryRouteArgs(
            key: key,
            entryId: entryId,
          ),
          rawPathParams: {'entryId': entryId},
          initialChildren: children,
        );

  static const String name = 'EditEntryRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<EditEntryRouteArgs>(
          orElse: () =>
              EditEntryRouteArgs(entryId: pathParams.getString('entryId')));
      return _i3.EditEntryScreen(
        key: args.key,
        entryId: args.entryId,
      );
    },
  );
}

class EditEntryRouteArgs {
  const EditEntryRouteArgs({
    this.key,
    required this.entryId,
  });

  final _i13.Key? key;

  final String entryId;

  @override
  String toString() {
    return 'EditEntryRouteArgs{key: $key, entryId: $entryId}';
  }
}

/// generated route for
/// [_i4.HelpSettingsScreen]
class HelpSettingsRoute extends _i12.PageRouteInfo<void> {
  const HelpSettingsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          HelpSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'HelpSettingsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i4.HelpSettingsScreen();
    },
  );
}

/// generated route for
/// [_i5.HomeScreen]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute({List<_i12.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i5.HomeScreen();
    },
  );
}

/// generated route for
/// [_i6.LoginScreen]
class LoginRoute extends _i12.PageRouteInfo<void> {
  const LoginRoute({List<_i12.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.LoginScreen();
    },
  );
}

/// generated route for
/// [_i3.NewEntryScreen]
class NewEntryRoute extends _i12.PageRouteInfo<void> {
  const NewEntryRoute({List<_i12.PageRouteInfo>? children})
      : super(
          NewEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewEntryRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i3.NewEntryScreen();
    },
  );
}

/// generated route for
/// [_i7.SearchScreen]
class SearchRoute extends _i12.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i13.Key? key,
    bool showHidden = false,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            showHidden: showHidden,
          ),
          rawQueryParams: {'showHidden': showHidden},
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<SearchRouteArgs>(
          orElse: () => SearchRouteArgs(
                  showHidden: queryParams.getBool(
                'showHidden',
                false,
              )));
      return _i7.SearchScreen(
        key: args.key,
        showHidden: args.showHidden,
      );
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({
    this.key,
    this.showHidden = false,
  });

  final _i13.Key? key;

  final bool showHidden;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, showHidden: $showHidden}';
  }
}

/// generated route for
/// [_i8.SecuritySettingsScreen]
class SecuritySettingsRoute extends _i12.PageRouteInfo<void> {
  const SecuritySettingsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SecuritySettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecuritySettingsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i8.SecuritySettingsScreen();
    },
  );
}

/// generated route for
/// [_i9.SettingsScreen]
class SettingsRoute extends _i12.PageRouteInfo<void> {
  const SettingsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i10.StylingSettingsScreen]
class StylingSettingsRoute extends _i12.PageRouteInfo<void> {
  const StylingSettingsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          StylingSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'StylingSettingsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i10.StylingSettingsScreen();
    },
  );
}

/// generated route for
/// [_i11.UserProfileScreen]
class UserProfileRoute extends _i12.PageRouteInfo<void> {
  const UserProfileRoute({List<_i12.PageRouteInfo>? children})
      : super(
          UserProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i11.UserProfileScreen();
    },
  );
}
