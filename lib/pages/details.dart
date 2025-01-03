import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fleather/fleather.dart' hide kToolbarHeight;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../components/journal_app_title.dart';
import '../components/journal_entry_tags.dart';
import '../helpers/db_watchers.dart';
import '../helpers/logger.dart';
import '../models/core.dart';
import '../models/drift.dart';

@RoutePage()
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    @queryParam this.showHidden = false,
    @queryParam this.entryId,
  });

  final bool showHidden;
  final String? entryId;

  static List<IconButton> detailsIcons(
      String journalEntryId, BuildContext context) {
    return [
      IconButton(
        onPressed: () async {
          final journalEntry = await (MyDatabase.instance
                  .select(MyDatabase.instance.journalEntry)
                ..where((tbl) => tbl.id.equals(journalEntryId)))
              .getSingle();
          await Clipboard.setData(
              ClipboardData(text: journalEntry.document.toPlainText()));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Copied to clipboard"),
            ),
          );
        },
        icon: Icon(Icons.copy),
      ),
      IconButton(
        onPressed: () async {
          final journalEntry = await (MyDatabase.instance
                  .select(MyDatabase.instance.journalEntry)
                ..where((tbl) => tbl.id.equals(journalEntryId)))
              .getSingle();
          final result = await Share.share(journalEntry.document.toPlainText());
          AppLogger.instance.i("Result: ${result.status}, raw: ${result.raw}");
        },
        icon: Icon(Icons.share),
      ),
      IconButton(
        onPressed: () async {
          AutoRouter.of(context).pushNamed("/editjournal/$journalEntryId");
        },
        icon: Icon(Icons.edit),
      ),
    ];
  }

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<JournalEntryData> _journalEntries = [];
  StreamSubscription<List<JournalEntryData>>? _subscription;
  String? _selectedEntryId;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _fetch() async {
    await _addWatcher();
    _setInitialEntry();
  }

  Future<void> _addWatcher() async {
    if (_subscription != null) {
      _subscription?.cancel();
    }
    _subscription = journalListSubscribe(
      showHidden: widget.showHidden,
    ).listen((entries) {
      setState(() {
        _journalEntries = entries;
      });
    });
  }

  void _setInitialEntry() {
    if (widget.entryId != null) {
      setState(() {
        _selectedEntryId = widget.entryId;
      });
    }
  }

  JournalEntryData? get _currentEntry {
    if (_currentIndex == -1) {
      return null;
    }
    return _journalEntries[_currentIndex];
  }

  int get _currentIndex {
    if (_journalEntries.isEmpty || _selectedEntryId == null) {
      return -1;
    }
    return _journalEntries.indexWhere((a) => a.id == _selectedEntryId);
  }

  AppBar _buildAppBar() {
    if (_currentEntry == null) {
      return AppBar();
    }
    final journalEntry = _currentEntry!;
    return AppBar(
      title: JournalAppTitle(
        journalEntry: journalEntry,
      ),
      actions: [
        ...DetailsScreen.detailsIcons(journalEntry.id, context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          final double width = MediaQuery.of(context).size.width;
          if (_journalEntries.isEmpty) {
            return Center(
              child: Text("Loading..."),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: height - kToolbarHeight - kToolbarHeight,
                  initialPage: _journalEntries
                      .indexWhere((a) => a.id == _selectedEntryId),
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (newPage, reason) {
                    setState(() {
                      final entry = _journalEntries[newPage];
                      setState(() {
                        _selectedEntryId = entry.id;
                      });
                    });
                  },
                ),
                itemCount: _journalEntries.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 18.0),
                  width: width,
                  child: JourneyDetailsView(
                    journalEntry: _journalEntries[itemIndex],
                  ),
                ),
              ),
              SizedBox(
                height: kToolbarHeight,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _currentIndex <= 0
                          ? null
                          : () {
                              _carouselController.previousPage();
                            },
                      icon: Icon(Icons.arrow_left),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                        ),
                        child: JournalEntryTags(journalEntry: _currentEntry!),
                      ),
                    ),
                    IconButton(
                      onPressed: (_currentIndex + 1) >= _journalEntries.length
                          ? null
                          : () {
                              _carouselController.nextPage();
                            },
                      icon: Icon(Icons.arrow_right),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class JourneyDetailsViewWrapper extends StatelessWidget {
  const JourneyDetailsViewWrapper({super.key, required this.entryId});
  final String entryId;

  Widget _build(BuildContext context, JournalEntryData? journalEntryData) {
    if (journalEntryData == null) {
      return Center(
        child: Text("Loading..."),
      );
    }
    return ListView(
      children: [
        JourneyDetailsView(
          journalEntry: journalEntryData,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<JournalEntryData>(
      stream: journalEntrySubscribe(
        entryId: entryId,
      ),
      builder: (context, journalEntryData) {
        return _build(context, journalEntryData.data);
      },
    );
  }
}

class JourneyDetailsView extends StatelessWidget {
  const JourneyDetailsView({
    super.key,
    required this.journalEntry,
  });

  final JournalEntryData journalEntry;

  @override
  Widget build(BuildContext context) {
    return FleatherEditor(
      scrollable: true,
      readOnly: true,
      showCursor: false,
      enableInteractiveSelection: true,
      controller: FleatherController(
        document: journalEntry.document,
      ),
    );
  }
}
