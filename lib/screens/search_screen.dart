import 'package:flutter/material.dart';

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
