import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_diary/utils/colors.dart';
import 'package:my_diary/widgets/text_color_picker.dart';
import 'package:my_diary/widgets/theme_picker.dart';
import 'package:my_diary/widgets/voice_input.dart';

class AddEntryPage extends StatefulWidget {
  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String? selectedEmoji;
  File? selectedImage;
  Color backgroundColor = const Color(0xFF0E1C2F);
  Color textColor = Colors.white;

  final ImagePicker _picker = ImagePicker();
  TextAlign selectedAlign = TextAlign.left;
  Color selectedTextColor = Colors.white;
  String selectedFontFamily = 'Roboto';
  double selectedFontSize = 18;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Navigator.pop(context, {
                    "date": DateFormat('dd MMM').format(selectedDate),
                    "title": titleController.text,
                    "desc": descController.text,
                    "emoji": selectedEmoji ?? '',
                    "imagePath": selectedImage?.path ?? '',
                  });
                }
              },
              child: Text("SAVE", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null &&
                              pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              DateFormat('dd').format(selectedDate),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              DateFormat('MMMM yyyy').format(selectedDate),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: textColor),
                          ],
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Text(
                          selectedEmoji ?? '😊',
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            backgroundColor: Color(0xFF1E2A47),
                            builder:
                                (_) => Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "How's your day?",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children:
                                            [
                                              "😐",
                                              "😊",
                                              "😁",
                                              "💖",
                                              "😃",
                                              "🙂",
                                              "😕",
                                              "😠",
                                              "😢",
                                              "😭",
                                              "😞",
                                              "😩",
                                            ].map((emoji) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedEmoji = emoji;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        selectedEmoji == emoji
                                                            ? Colors
                                                                .purple
                                                                .shade200
                                                            : Colors
                                                                .transparent,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    emoji,
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    style: TextStyle(color: textColor, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descController,
                    style: TextStyle(color: textColor),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Write more here...",
                      hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[700]?.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "# Ghjn",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  if (selectedImage != null) ...[
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        selectedImage!,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF0E1C2F),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.line_weight_rounded, color: Colors.white),
                    onPressed: () {
                      ThemePicker.show(
                        context: context,
                        currentColor: backgroundColor,
                        onSelected: (color) {
                          setState(() {
                            backgroundColor = color;
                          });
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.image_outlined, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                  IconButton(
                    icon: Icon(Icons.star_border, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.text_fields, color: Colors.white),
                    onPressed: () {
                      TextColorPicker.show(
                        context: context,
                        currentColor: textColor,
                        onSelected: (color) {
                          setState(() {
                            textColor = color;
                          });
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.sell_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.mic_none_outlined, color: Colors.white),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => VoiceInput(
                                onTextRecognized: (spokenText) {
                                  // Append to description or title as needed
                                  descController.text += spokenText + " ";
                                  // or: titleController.text += spokenText + " ";
                                },
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
