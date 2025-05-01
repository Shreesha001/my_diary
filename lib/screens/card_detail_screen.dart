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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
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
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "Delete",
                  style: TextStyle(color: whiteColor, fontSize: 16),
                ),
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      Navigator.pop(context, 'delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            tooltip: "Delete Entry",
            onPressed: _deleteEntry,
          ),
          Container(
            margin: EdgeInsets.only(right: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Blue background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
              ),
              onPressed: _saveChanges,
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Text(
                'Title',
                style: TextStyle(
                  fontSize: 16,
                  color: textSecondaryColor.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: _titleController,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                    hintText: 'Enter title...',
                    hintStyle: TextStyle(
                      color: textSecondaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Description Section
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  color: textSecondaryColor.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: _descController,
                  maxLines: 5,
                  style: TextStyle(fontSize: 16, color: textSecondaryColor),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                    hintText: 'Write your thoughts...',
                    hintStyle: TextStyle(
                      color: textSecondaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28),

              // Image Section
              Text(
                'Image',
                style: TextStyle(
                  fontSize: 16,
                  color: textSecondaryColor.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),
              if (_selectedImage != null && _selectedImage!.existsSync())
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: _deleteImage,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: textSecondaryColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: textSecondaryColor.withOpacity(0.4),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "No image selected",
                        style: TextStyle(
                          color: textSecondaryColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _pickImage,
                    icon: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: whiteColor,
                    ),
                    label: Text(
                      "Select Image",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
