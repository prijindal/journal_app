// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:flutter/material.dart' as _i18;
import 'package:journal_app/pages/details.dart' as _i2;
import 'package:journal_app/pages/editentry.dart' as _i3;
import 'package:journal_app/pages/home/calendar.dart' as _i10;
import 'package:journal_app/pages/home/index.dart' as _i9;
import 'package:journal_app/pages/home/journallist.dart' as _i11;
import 'package:journal_app/pages/newentry.dart' as _i12;
import 'package:journal_app/pages/search.dart' as _i13;
import 'package:journal_app/pages/settings/backup/firebase/firebase_login.dart'
    as _i5;
import 'package:journal_app/pages/settings/backup/firebase/firebase_profile.dart'
    as _i6;
import 'package:journal_app/pages/settings/backup/firebase/firebase_screen.dart'
    as _i4;
import 'package:journal_app/pages/settings/backup/gdrive/gdrive_screen.dart'
    as _i7;
import 'package:journal_app/pages/settings/backup/index.dart' as _i1;
import 'package:journal_app/pages/settings/help.dart' as _i8;
import 'package:journal_app/pages/settings/index.dart' as _i15;
import 'package:journal_app/pages/settings/security.dart' as _i14;
import 'package:journal_app/pages/settings/styling.dart' as _i16;

/// generated route for
/// [_i1.BackupSettingsScreen]
class BackupSettingsRoute extends _i17.PageRouteInfo<void> {
  const BackupSettingsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          BackupSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'BackupSettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i1.BackupSettingsScreen();
    },
  );
}

/// generated route for
/// [_i2.DetailsScreen]
class DetailsRoute extends _i17.PageRouteInfo<DetailsRouteArgs> {
  DetailsRoute({
    _i18.Key? key,
    bool showHidden = false,
    String? entryId,
    List<_i17.PageRouteInfo>? children,
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

  static _i17.PageInfo page = _i17.PageInfo(
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

  final _i18.Key? key;

  final bool showHidden;

  final String? entryId;

  @override
  String toString() {
    return 'DetailsRouteArgs{key: $key, showHidden: $showHidden, entryId: $entryId}';
  }
}

/// generated route for
/// [_i3.EditEntryScreen]
class EditEntryRoute extends _i17.PageRouteInfo<EditEntryRouteArgs> {
  EditEntryRoute({
    _i18.Key? key,
    required String entryId,
    List<_i17.PageRouteInfo>? children,
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

  static _i17.PageInfo page = _i17.PageInfo(
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

  final _i18.Key? key;

  final String entryId;

  @override
  String toString() {
    return 'EditEntryRouteArgs{key: $key, entryId: $entryId}';
  }
}

/// generated route for
/// [_i4.FirebaseBackupScreen]
class FirebaseBackupRoute extends _i17.PageRouteInfo<void> {
  const FirebaseBackupRoute({List<_i17.PageRouteInfo>? children})
      : super(
          FirebaseBackupRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirebaseBackupRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i4.FirebaseBackupScreen();
    },
  );
}

/// generated route for
/// [_i5.FirebaseLoginScreen]
class FirebaseLoginRoute extends _i17.PageRouteInfo<void> {
  const FirebaseLoginRoute({List<_i17.PageRouteInfo>? children})
      : super(
          FirebaseLoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirebaseLoginRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i5.FirebaseLoginScreen();
    },
  );
}

/// generated route for
/// [_i6.FirebaseProfileScreen]
class FirebaseProfileRoute extends _i17.PageRouteInfo<void> {
  const FirebaseProfileRoute({List<_i17.PageRouteInfo>? children})
      : super(
          FirebaseProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirebaseProfileRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i6.FirebaseProfileScreen();
    },
  );
}

/// generated route for
/// [_i7.GDriveBackupScreen]
class GDriveBackupRoute extends _i17.PageRouteInfo<void> {
  const GDriveBackupRoute({List<_i17.PageRouteInfo>? children})
      : super(
          GDriveBackupRoute.name,
          initialChildren: children,
        );

  static const String name = 'GDriveBackupRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i7.GDriveBackupScreen();
    },
  );
}

/// generated route for
/// [_i8.HelpSettingsScreen]
class HelpSettingsRoute extends _i17.PageRouteInfo<void> {
  const HelpSettingsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          HelpSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'HelpSettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i8.HelpSettingsScreen();
    },
  );
}

/// generated route for
/// [_i9.HomeScreen]
class HomeRoute extends _i17.PageRouteInfo<void> {
  const HomeRoute({List<_i17.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i9.HomeScreen();
    },
  );
}

/// generated route for
/// [_i10.JournalCalendarScreen]
class JournalCalendarRoute extends _i17.PageRouteInfo<void> {
  const JournalCalendarRoute({List<_i17.PageRouteInfo>? children})
      : super(
          JournalCalendarRoute.name,
          initialChildren: children,
        );

  static const String name = 'JournalCalendarRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i10.JournalCalendarScreen();
    },
  );
}

/// generated route for
/// [_i11.JournalListScreen]
class JournalListRoute extends _i17.PageRouteInfo<void> {
  const JournalListRoute({List<_i17.PageRouteInfo>? children})
      : super(
          JournalListRoute.name,
          initialChildren: children,
        );

  static const String name = 'JournalListRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i11.JournalListScreen();
    },
  );
}

/// generated route for
/// [_i12.NewEntryScreen]
class NewEntryRoute extends _i17.PageRouteInfo<void> {
  const NewEntryRoute({List<_i17.PageRouteInfo>? children})
      : super(
          NewEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewEntryRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i12.NewEntryScreen();
    },
  );
}

/// generated route for
/// [_i13.SearchScreen]
class SearchRoute extends _i17.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i18.Key? key,
    bool showHidden = false,
    List<_i17.PageRouteInfo>? children,
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

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<SearchRouteArgs>(
          orElse: () => SearchRouteArgs(
                  showHidden: queryParams.getBool(
                'showHidden',
                false,
              )));
      return _i13.SearchScreen(
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

  final _i18.Key? key;

  final bool showHidden;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, showHidden: $showHidden}';
  }
}

/// generated route for
/// [_i14.SecuritySettingsScreen]
class SecuritySettingsRoute extends _i17.PageRouteInfo<void> {
  const SecuritySettingsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SecuritySettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecuritySettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i14.SecuritySettingsScreen();
    },
  );
}

/// generated route for
/// [_i15.SettingsScreen]
class SettingsRoute extends _i17.PageRouteInfo<void> {
  const SettingsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i15.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i16.StylingSettingsScreen]
class StylingSettingsRoute extends _i17.PageRouteInfo<void> {
  const StylingSettingsRoute({List<_i17.PageRouteInfo>? children})
      : super(
          StylingSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'StylingSettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i16.StylingSettingsScreen();
    },
  );
}
