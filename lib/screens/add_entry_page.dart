import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEntryPage extends StatefulWidget {
  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String selectedEmoji = "";
  File? selectedImage;

  final ImagePicker _picker = ImagePicker();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectEmoji(String emoji) {
    setState(() {
      selectedEmoji = emoji;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1A2D),
      appBar: AppBar(
        title: Text("Add New Entry"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextButton.icon(
              onPressed: _pickDate,
              icon: Icon(Icons.calendar_today, color: Colors.white),
              label: Text(
                DateFormat('dd MMM yyyy').format(selectedDate),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descController,
              style: TextStyle(color: Colors.white),
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "How was your day?",
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children:
                  ["😄", "🙂", "😐", "😔", "😢", "😡"].map((emoji) {
                    return GestureDetector(
                      onTap: () => _selectEmoji(emoji),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              selectedEmoji == emoji
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                          border: Border.all(color: Colors.white70),
                        ),
                        child: Text(emoji, style: TextStyle(fontSize: 24)),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text("Add Image (Optional)"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
            ),
            if (selectedImage != null) ...[
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  selectedImage!,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Navigator.pop(context, {
                    "date": DateFormat('dd MMM').format(selectedDate),
                    "title": titleController.text,
                    "desc": descController.text,
                    "emoji": selectedEmoji,
                    "imagePath": selectedImage?.path ?? '',
                  });
                }
              },
              child: Text("Save Entry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
