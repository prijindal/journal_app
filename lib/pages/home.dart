import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const addHabbitShortcut = "add_habbit";

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _showHidden = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Journal"),
      ),
      body: Center(
        child: Text("Here lieth the journalth list"),
      ),
      // floatingActionButtonLocation:
      //     MediaQuery.of(context).size.width > mediaBreakpointHorizontal
      //         ? FloatingActionButtonLocation.startFloat
      //         : FloatingActionButtonLocation.endFloat,
      // floatingActionButton: _buildFab(),
      // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
