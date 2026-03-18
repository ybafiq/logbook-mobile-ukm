import 'package:flutter/material.dart';
import 'package:logbook_ukm/models/projectentry_models.dart';
import 'package:logbook_ukm/services/projectdatabase_services.dart';

class EditProjectEntryPage extends StatefulWidget {
  final ProjectEntry entry;
  const EditProjectEntryPage({super.key, required this.entry});

  @override
  State<EditProjectEntryPage> createState() => _EditProjectEntryPageState();
}

class _EditProjectEntryPageState extends State<EditProjectEntryPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _activityController;
  late TextEditingController _improvementController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _activityController = TextEditingController(text: widget.entry.activity);
    _improvementController =
        TextEditingController(text: widget.entry.improvement ?? '');
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedEntry = ProjectEntry(
        id: widget.entry.id,
        title: _titleController.text,
        activity: _activityController.text,
        comment: widget.entry.comment,
        date: widget.entry.date,
        improvement: _improvementController.text.isNotEmpty
            ? _improvementController.text
            : null,
        userId: '',
      );

      await ProjectDatabaseHelper().updateProjectEntry(updatedEntry);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry updated successfully!')),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmBlue = Color(0xFF005DAA);
    const Color ukmYellow = Color(0xFFF7B500);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Entry',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: ukmRed,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Activity',
                  prefixIcon: Icon(Icons.work, color: ukmBlue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter activity' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _activityController,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  prefixIcon: Icon(Icons.comment, color: ukmBlue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter comment' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _improvementController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Weekly Improvement (Optional)',
                  prefixIcon: Icon(Icons.lightbulb, color: ukmYellow),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ukmRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _saveChanges,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

