import 'package:flutter/material.dart';
import 'package:logbook_ukm/models/projectentry_models.dart';
import 'package:logbook_ukm/screen/project/edit_projectentry_screen.dart';
import 'package:logbook_ukm/screen/project/view_projectentry_screen.dart';
import 'package:logbook_ukm/services/pdfproject_services.dart';
import 'package:logbook_ukm/services/projectdatabase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProjectEntriesPage extends StatefulWidget {
  const ViewProjectEntriesPage({super.key});

  @override
  State<ViewProjectEntriesPage> createState() => _ViewProjectEntriesPageState();
}

class _ViewProjectEntriesPageState extends State<ViewProjectEntriesPage> {
  List<ProjectEntry> _entries = [];

  get projectId => null;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await ProjectDatabaseHelper().getProjectEntries(userId: '');
    setState(() {
      _entries = entries;
    });
  }

  Future<void> _deleteEntry(ProjectEntry entry) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this project entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ProjectDatabaseHelper().deleteProjectEntry(entry.id!);
      _loadEntries();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry deleted successfully!')),
      );
    }
  }

  void _exportToPdf2() async {
    if (_entries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No entries to export!')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'Unknown Student';
    final matricno = prefs.getString('matricno') ?? 'N/A';
    final workplace = prefs.getString('workplace') ?? 'N/A';

    await generatePdf2(
      _entries,
      username: username,
      matricno: matricno,
      workplace: workplace,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF exported successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmBlue = Color(0xFF005DAA);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Project Entries",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: ukmRed,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _exportToPdf2,
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: _entries.isEmpty
          ? const Center(
              child: Text(
                "No project entries found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.date,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ukmBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Activity: ${entry.title}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Comment: ${entry.activity}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: ukmRed),
                        ),
                        const SizedBox(height: 8),
                        if (entry.improvement != null &&
                            entry.improvement!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            "Improvement: ${entry.improvement}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFBE1E2D),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // View button
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ukmBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ViewSingleProjectEntryPage(entry: entry),
                                ),
                              ),
                              icon: const Icon(Icons.visibility,
                                  color: Colors.white),
                              label: const Text(
                                'View',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // ✏️ Edit button
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditProjectEntryPage(entry: entry),
                                  ),
                                );
                                _loadEntries();
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 🗑️ Delete button
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ukmRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => _deleteEntry(entry),
                              icon: const Icon(Icons.delete,
                                  color: Colors.white),
                              label: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

