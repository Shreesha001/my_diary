import 'package:flutter/material.dart';
import 'package:my_diary/screens/add_entry_page.dart';
import 'package:my_diary/screens/card_detail_screen.dart';
import 'package:my_diary/screens/search_screen.dart';
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
          Expanded(
            child: ListView.builder(
              itemCount: filteredEntries.length,
              itemBuilder: (context, index) {
                final entry = filteredEntries[index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CardDetailScreen(entry: entry),
                      ),
                    );

                    if (result == 'delete') {
                      // User confirmed deletion
                      setState(() {
                        entries.removeAt(index);
                      });
                    } else if (result is Map<String, dynamic>) {
                      // User saved updated entry
                      setState(() {
                        entries[index] = result;
                      });
                    }
                    // else: user just went back, do nothing
                  },

                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: cardColor, // Updated to use palette color
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
                                  color: whiteColor, // From palette
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
                                ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry["title"] ?? '',
                                      style: TextStyle(
                                        color: whiteColor, // From palette
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      entry["desc"] ?? '',
                                      style: TextStyle(
                                        color: whiteColor.withOpacity(0.8),
                                      ),
                                      maxLines: 1,
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
