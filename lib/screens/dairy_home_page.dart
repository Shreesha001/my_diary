import 'package:flutter/material.dart';
import 'package:my_diary/screens/add_entry_page.dart';
import 'package:my_diary/utils/colors.dart';
import 'dart:io';

class DiaryHomePage extends StatefulWidget {
  @override
  _DiaryHomePageState createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> entries = []; // Cleared hardcoded entries

  List<Map<String, dynamic>> get filteredEntries {
    if (searchController.text.isEmpty) return entries;
    return entries
        .where(
          (entry) =>
              entry["title"].toLowerCase().contains(
                searchController.text.toLowerCase(),
              ) ||
              entry["desc"].toLowerCase().contains(
                searchController.text.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarColor,
        title: Text("My Diary"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DiarySearchDelegate(entries),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "3-Day Habit Challenge",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEntries.length,
              itemBuilder: (context, index) {
                final entry = filteredEntries[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.blueGrey.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry["date"] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              entry["emoji"] ?? '',
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (entry["imagePath"] != null &&
                                entry["imagePath"].isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(entry["imagePath"]),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.image, color: Colors.white30),
                              ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry["title"] ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    entry["desc"] ?? '',
                                    style: TextStyle(color: Colors.white70),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEntry = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEntryPage()),
          );

          if (newEntry != null) {
            setState(() {
              entries.add(newEntry);
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

class DiarySearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> entries;

  DiarySearchDelegate(this.entries);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        entries
            .where(
              (entry) =>
                  entry['title'].toLowerCase().contains(query.toLowerCase()) ||
                  entry['desc'].toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView(
      children:
          results
              .map(
                (entry) => ListTile(
                  title: Text(entry['title']),
                  subtitle: Text(entry['desc']),
                ),
              )
              .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        entries
            .where(
              (entry) =>
                  entry['title'].toLowerCase().contains(query.toLowerCase()) ||
                  entry['desc'].toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView(
      children:
          suggestions
              .map(
                (entry) => ListTile(
                  title: Text(entry['title']),
                  subtitle: Text(entry['desc']),
                ),
              )
              .toList(),
    );
  }
}
