import 'package:flutter/material.dart';
import 'task.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<Task> searchResults;

  SearchResultsScreen({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final task = searchResults[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact Name: ${task.contactName}'),
                Text('Phone Number: ${task.phoneNumber}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
