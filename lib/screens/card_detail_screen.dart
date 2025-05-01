import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/colors.dart';

class CardDetailScreen extends StatefulWidget {
  final Map<String, dynamic> entry;

  const CardDetailScreen({Key? key, required this.entry}) : super(key: key);

  @override
  _CardDetailScreenState createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry['title']);
    _descController = TextEditingController(text: widget.entry['desc']);

    final path = widget.entry['imagePath'];
    if (path != null &&
        path is String &&
        path.isNotEmpty &&
        File(path).existsSync()) {
      _selectedImage = File(path);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _saveChanges() {
    Navigator.pop(context, {
      'title': _titleController.text,
      'desc': _descController.text,
      'imagePath': _selectedImage?.path ?? '',
      'date': widget.entry['date'],
      'emoji': widget.entry['emoji'],
    });
  }

  void _deleteEntry() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: secondaryColor,
            title: Text(
              "Delete Entry",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Are you sure you want to delete this entry? This action cannot be undone.",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Cancel
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, true), // Confirm
                child: Text(
                  "Delete",
                  style: TextStyle(color: whiteColor, fontSize: 16),
                ),
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      Navigator.pop(context, 'delete'); // Use a distinct string
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Entry Detail"),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            tooltip: "Delete Entry",
            onPressed: _deleteEntry,
          ),
          IconButton(
            icon: Icon(Icons.save, color: whiteColor),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: textSecondaryColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _descController,
                maxLines: null,
                style: TextStyle(fontSize: 16, color: textSecondaryColor),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: textSecondaryColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_selectedImage != null && _selectedImage!.existsSync())
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _deleteImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Text("No image selected", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: _pickImage,
                icon: Icon(Icons.image, color: whiteColor),
                label: Text("Pick Image", style: TextStyle(color: whiteColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
