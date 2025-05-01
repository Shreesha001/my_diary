import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart'; // Make sure your color constants are stored here

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
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              surface: whiteColor,
              onSurface: textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Add New Entry", style: TextStyle(color: whiteColor)),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: whiteColor),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextButton.icon(
              onPressed: _pickDate,
              icon: Icon(Icons.calendar_today, color: primaryColor),
              label: Text(
                DateFormat('dd MMM yyyy').format(selectedDate),
                style: TextStyle(color: textPrimaryColor),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              style: TextStyle(color: textPrimaryColor),
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: textSecondaryColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descController,
              style: TextStyle(color: textPrimaryColor),
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(color: textSecondaryColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "How was your day?",
              style: TextStyle(fontSize: 18, color: textSecondaryColor),
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
                                  ? primarylightColor
                                  : Colors.transparent,
                          border: Border.all(color: primaryColor),
                        ),
                        child: Text(emoji, style: TextStyle(fontSize: 24)),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image, color: whiteColor),
              label: Text(
                "Add Image (Optional)",
                style: TextStyle(color: whiteColor),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
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
              child: Text("Save Entry", style: TextStyle(color: whiteColor)),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
