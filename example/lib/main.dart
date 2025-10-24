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
        home: SearchExamplePage(),
      ),
    );
  }
}

class SearchExamplePage extends StatefulWidget {
  const SearchExamplePage({super.key});

  @override
  State<SearchExamplePage> createState() => _SearchExamplePageState();
}

class _SearchExamplePageState extends State<SearchExamplePage> {
  late final TextEditingController textController;
  late final ExpandableSearchBarPlusController barController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    barController = ExpandableSearchBarPlusController();
  }

  @override
  void dispose() {
    textController.dispose();
    barController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpandableSearchBarPlus(
              controller: textController,
              barController: barController,
              hintText: "Search here...",
              onChanged: print,
              onTap: (expanded) =>
                  debugPrint(expanded ? "Expanded" : "Collapsed"),
              supportMouse: true,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: barController.expand,
                  child: const Text("Expand"),
                ),
                ElevatedButton(
                  onPressed: barController.collapse,
                  child: const Text("Collapse"),
                ),
                ElevatedButton(
                  onPressed: barController.toggle,
                  child: const Text("Toggle"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
