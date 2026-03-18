import 'package:flutter/material.dart';
import 'package:logbook_ukm/models/logbookentry_models.dart';
import 'package:logbook_ukm/services/dailydatabase_services.dart';

class EditEntryPage extends StatefulWidget {
  final LogbookEntry entry;

  const EditEntryPage({super.key, required this.entry});

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _descriptionController =
        TextEditingController(text: widget.entry.description);
    _dateController =
        TextEditingController(text: widget.entry.date.toString().split(' ')[0]);
  }

  Future<void> _saveChanges() async {
    final updatedEntry = LogbookEntry(
      id: widget.entry.id,
      title: _titleController.text,
      description: _descriptionController.text,
      date: DateTime.parse(_dateController.text), 
      userId: '',
    );

    await LogbookDatabaseHelper().updateLogbookEntry(updatedEntry);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmBlue = Color(0xFF005DAA);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Entry",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: ukmRed,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date',
                prefixIcon: const Icon(Icons.calendar_today, color: ukmBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: widget.entry.date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _dateController.text =
                        picked.toString().split(' ')[0];
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: const Icon(Icons.work, color: ukmBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Comment',
                prefixIcon: const Icon(Icons.comment, color: ukmBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ukmRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              onPressed: _saveChanges,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'Save Changes',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

