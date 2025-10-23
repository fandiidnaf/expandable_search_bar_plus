import 'package:expandable_search_bar_plus/expandable_search_bar_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ExampleSearchBar(),
      ),
    );
  }
}

class ExampleSearchBar extends StatefulWidget {
  const ExampleSearchBar({super.key});

  @override
  State<ExampleSearchBar> createState() => _ExampleSearchBarState();
}

class _ExampleSearchBarState extends State<ExampleSearchBar> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExpandableSearchBarPlus(
          onTap: () => print("search : ${searchController.text}"),
          hintText: "Search something",
          controller: searchController,
         supportMouse: true,
        ),
      ),
    );
  }
}