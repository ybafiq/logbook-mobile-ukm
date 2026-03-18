import 'package:flutter/material.dart';
import 'package:logbook_ukm/models/logbookentry_models.dart';
import 'package:logbook_ukm/screen/daily/edit_dailyentry_screen.dart';
import 'package:logbook_ukm/screen/daily/view_dailyentry_screen.dart';
import 'package:logbook_ukm/services/dailydatabase_services.dart';
import 'package:logbook_ukm/services/pdfdaily_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewEntriesPage extends StatefulWidget {
  const ViewEntriesPage({super.key});

  @override
  State<ViewEntriesPage> createState() => _ViewEntriesPageState();
}

class _ViewEntriesPageState extends State<ViewEntriesPage> {
  List<LogbookEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await LogbookDatabaseHelper().getLogbookEntries(userId: '');
    setState(() {
      _entries = entries;
    });
  }

  Future<void> _deleteEntry(LogbookEntry entry) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
            'Are you sure you want to delete this logbook entry? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await LogbookDatabaseHelper().deleteLogbookEntry(entry.id!);
      _loadEntries();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry deleted successfully.')),
      );
    }
  }

  void _exportToPdf() async {
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

    await generatePdf(
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "All Logbook Entries",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: ukmRed,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: _exportToPdf,
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: _entries.isEmpty
          ? const Center(
              child: Text(
                "No entries found. Add some in the Logbook page!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
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
                          entry.date.toLocal().toString().split(' ')[0],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ukmBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Description: ${entry.title}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Comment: ${entry.description}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: ukmRed,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // 👁️ View button
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
                                      ViewSingleEntryPage(entry: entry),
                                ),
                              ),
                              icon: const Icon(Icons.visibility,
                                  color: Colors.white),
                              label: const Text(
                                'View',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
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
                                        EditEntryPage(entry: entry),
                                  ),
                                );
                                _loadEntries();
                              },
                              icon:
                                  const Icon(Icons.edit, color: Colors.white),
                              label: const Text(
                                'Edit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
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
                                    fontWeight: FontWeight.bold),
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

