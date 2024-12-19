// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;
import 'package:journal_app/pages/details.dart' as _i2;
import 'package:journal_app/pages/editentry.dart' as _i3;
import 'package:journal_app/pages/home/calendar.dart' as _i6;
import 'package:journal_app/pages/home/index.dart' as _i5;
import 'package:journal_app/pages/home/journallist.dart' as _i7;
import 'package:journal_app/pages/login.dart' as _i8;
import 'package:journal_app/pages/newentry.dart' as _i9;
import 'package:journal_app/pages/profile.dart' as _i14;
import 'package:journal_app/pages/search.dart' as _i10;
import 'package:journal_app/pages/settings/backup.dart' as _i1;
import 'package:journal_app/pages/settings/help.dart' as _i4;
import 'package:journal_app/pages/settings/index.dart' as _i12;
import 'package:journal_app/pages/settings/security.dart' as _i11;
import 'package:journal_app/pages/settings/styling.dart' as _i13;

/// generated route for
/// [_i1.BackupSettingsScreen]
class BackupSettingsRoute extends _i15.PageRouteInfo<void> {
  const BackupSettingsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          BackupSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'BackupSettingsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i1.BackupSettingsScreen();
    },
  );
}

/// generated route for
/// [_i2.DetailsScreen]
class DetailsRoute extends _i15.PageRouteInfo<DetailsRouteArgs> {
  DetailsRoute({
    _i16.Key? key,
    bool showHidden = false,
    String? entryId,
    List<_i15.PageRouteInfo>? children,
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

  static _i15.PageInfo page = _i15.PageInfo(
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

  final _i16.Key? key;

  final bool showHidden;

  final String? entryId;

  @override
  String toString() {
    return 'DetailsRouteArgs{key: $key, showHidden: $showHidden, entryId: $entryId}';
  }
}

/// generated route for
/// [_i3.EditEntryScreen]
class EditEntryRoute extends _i15.PageRouteInfo<EditEntryRouteArgs> {
  EditEntryRoute({
    _i16.Key? key,
    required String entryId,
    List<_i15.PageRouteInfo>? children,
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

  static _i15.PageInfo page = _i15.PageInfo(
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

  final _i16.Key? key;

  final String entryId;

  @override
  String toString() {
    return 'EditEntryRouteArgs{key: $key, entryId: $entryId}';
  }
}

/// generated route for
/// [_i4.HelpSettingsScreen]
class HelpSettingsRoute extends _i15.PageRouteInfo<void> {
  const HelpSettingsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          HelpSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'HelpSettingsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i4.HelpSettingsScreen();
    },
  );
}

/// generated route for
/// [_i5.HomeScreen]
class HomeRoute extends _i15.PageRouteInfo<void> {
  const HomeRoute({List<_i15.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i5.HomeScreen();
    },
  );
}

/// generated route for
/// [_i6.JournalCalendarScreen]
class JournalCalendarRoute
    extends _i15.PageRouteInfo<JournalCalendarRouteArgs> {
  JournalCalendarRoute({
    _i16.Key? key,
    required bool showHidden,
    String? searchText,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          JournalCalendarRoute.name,
          args: JournalCalendarRouteArgs(
            key: key,
            showHidden: showHidden,
            searchText: searchText,
          ),
          initialChildren: children,
        );

  static const String name = 'JournalCalendarRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<JournalCalendarRouteArgs>();
      return _i6.JournalCalendarScreen(
        key: args.key,
        showHidden: args.showHidden,
        searchText: args.searchText,
      );
    },
  );
}

class JournalCalendarRouteArgs {
  const JournalCalendarRouteArgs({
    this.key,
    required this.showHidden,
    this.searchText,
  });

  final _i16.Key? key;

  final bool showHidden;

  final String? searchText;

  @override
  String toString() {
    return 'JournalCalendarRouteArgs{key: $key, showHidden: $showHidden, searchText: $searchText}';
  }
}

/// generated route for
/// [_i7.JournalListScreen]
class JournalListRoute extends _i15.PageRouteInfo<JournalListRouteArgs> {
  JournalListRoute({
    _i16.Key? key,
    required bool showHidden,
    required List<String> selectedEntries,
    required String? selectedEntryId,
    required void Function(String?) onSetSelectedEntryIndex,
    required void Function(List<String>)? onSelectedEntriesChange,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          JournalListRoute.name,
          args: JournalListRouteArgs(
            key: key,
            showHidden: showHidden,
            selectedEntries: selectedEntries,
            selectedEntryId: selectedEntryId,
            onSetSelectedEntryIndex: onSetSelectedEntryIndex,
            onSelectedEntriesChange: onSelectedEntriesChange,
          ),
          initialChildren: children,
        );

  static const String name = 'JournalListRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<JournalListRouteArgs>();
      return _i7.JournalListScreen(
        key: args.key,
        showHidden: args.showHidden,
        selectedEntries: args.selectedEntries,
        selectedEntryId: args.selectedEntryId,
        onSetSelectedEntryIndex: args.onSetSelectedEntryIndex,
        onSelectedEntriesChange: args.onSelectedEntriesChange,
      );
    },
  );
}

class JournalListRouteArgs {
  const JournalListRouteArgs({
    this.key,
    required this.showHidden,
    required this.selectedEntries,
    required this.selectedEntryId,
    required this.onSetSelectedEntryIndex,
    required this.onSelectedEntriesChange,
  });

  final _i16.Key? key;

  final bool showHidden;

  final List<String> selectedEntries;

  final String? selectedEntryId;

  final void Function(String?) onSetSelectedEntryIndex;

  final void Function(List<String>)? onSelectedEntriesChange;

  @override
  String toString() {
    return 'JournalListRouteArgs{key: $key, showHidden: $showHidden, selectedEntries: $selectedEntries, selectedEntryId: $selectedEntryId, onSetSelectedEntryIndex: $onSetSelectedEntryIndex, onSelectedEntriesChange: $onSelectedEntriesChange}';
  }
}

/// generated route for
/// [_i8.LoginScreen]
class LoginRoute extends _i15.PageRouteInfo<void> {
  const LoginRoute({List<_i15.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i8.LoginScreen();
    },
  );
}

/// generated route for
/// [_i9.NewEntryScreen]
class NewEntryRoute extends _i15.PageRouteInfo<void> {
  const NewEntryRoute({List<_i15.PageRouteInfo>? children})
      : super(
          NewEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewEntryRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i9.NewEntryScreen();
    },
  );
}

/// generated route for
/// [_i10.SearchScreen]
class SearchRoute extends _i15.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i16.Key? key,
    bool showHidden = false,
    List<_i15.PageRouteInfo>? children,
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

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<SearchRouteArgs>(
          orElse: () => SearchRouteArgs(
                  showHidden: queryParams.getBool(
                'showHidden',
                false,
              )));
      return _i10.SearchScreen(
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

  final _i16.Key? key;

  final bool showHidden;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, showHidden: $showHidden}';
  }
}

/// generated route for
/// [_i11.SecuritySettingsScreen]
class SecuritySettingsRoute extends _i15.PageRouteInfo<void> {
  const SecuritySettingsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SecuritySettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecuritySettingsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i11.SecuritySettingsScreen();
    },
  );
}

/// generated route for
/// [_i12.SettingsScreen]
class SettingsRoute extends _i15.PageRouteInfo<void> {
  const SettingsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i12.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i13.StylingSettingsScreen]
class StylingSettingsRoute extends _i15.PageRouteInfo<void> {
  const StylingSettingsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          StylingSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'StylingSettingsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i13.StylingSettingsScreen();
    },
  );
}

/// generated route for
/// [_i14.UserProfileScreen]
class UserProfileRoute extends _i15.PageRouteInfo<void> {
  const UserProfileRoute({List<_i15.PageRouteInfo>? children})
      : super(
          UserProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i14.UserProfileScreen();
    },
  );
}
