import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../components/journal_list.dart';
import '../helpers/theme.dart';
import '../models/core.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    @queryParam this.showHidden = false,
  });
  final bool showHidden;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchQueryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchQueryController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search Data...",
            border: InputBorder.none,
            hintStyle: ThemeDataWrapper.of(context).searchHintStyle,
          ),
          style: ThemeDataWrapper.of(context).searchLabelStyle,
          onChanged: (newValue) {
            setState(() {});
          },
        ),
      ),
      body: _searchQueryController.text.isEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Enter a search query...")],
            )
          : JournalListWrapper(
              key: Key(
                "JournalListWrapper${widget.showHidden}${_searchQueryController.text}",
              ),
              showHidden: widget.showHidden,
              searchText: _searchQueryController.text,
              onTap: (JournalEntryData journalEntry) {
                AutoRouter.of(context).pushNamed(
                    "/details?entryId=${journalEntry.id}&showHidden=${widget.showHidden}");
              },
            ),
    );
  }
}
