import 'package:flutter/material.dart';
import 'package:logbook_ukm/screen/home_screen.dart';
import 'package:logbook_ukm/screen/project/projectentry_screen.dart';
import 'package:logbook_ukm/models/projectentry_models.dart';
import 'package:logbook_ukm/services/projectdatabase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectLogbookPage extends StatefulWidget {
  const ProjectLogbookPage({super.key});

  @override
  State<ProjectLogbookPage> createState() => _ProjectLogbookPageState();
}

class _ProjectLogbookPageState extends State<ProjectLogbookPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController(); // Activity
  final _description = TextEditingController(); // Comment
  final _date = TextEditingController();
  final _improvement = TextEditingController();

  get projectId => null; // Optional Weekly Reflection

  @override
  void initState() {
    super.initState();
    _loadEntries(); // Load saved entries when the page opens
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _date.dispose();
    _improvement.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    await ProjectDatabaseHelper().getProjectEntries(userId: '');
    setState(() {});
  }

  // ✅ UPDATED SECTION BELOW
  void _saveLog() async {
    if (_formKey.currentState!.validate()) {
      final selectedDate = DateTime.parse(_date.text);
      final db = ProjectDatabaseHelper();

      // ✅ Load existing entries
      final existingEntries = await db.getProjectEntries(userId: '');

      // ✅ Check if entry for the same date already exists
      final hasEntryToday = existingEntries.any(
        (entry) => entry.date == _date.text,
      ); // Date is stored as string (YYYY-MM-DD)

      if (hasEntryToday) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only make one entry per day!')),
        );
        return;
      }

      // ✅ Check if improvement already exists in the past 7 days
      if (_improvement.text.isNotEmpty) {
        final hasWeeklyImprovement = existingEntries.any((entry) {
          if (entry.improvement == null || entry.improvement!.isEmpty)
            return false;
          final entryDate = DateTime.parse(entry.date);
          final difference = selectedDate.difference(entryDate).inDays;
          return difference.abs() < 7; // Within same week window
        });

        if (hasWeeklyImprovement) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can only add one improvement per week!'),
            ),
          );
          return;
        }
      }

      // ✅ Save if passes checks
      final entry = ProjectEntry(
        title: _title.text,
        activity: _description.text,
        comment: '',
        date: _date.text,
        improvement: _improvement.text.isNotEmpty ? _improvement.text : null,
        userId: '',
      );

      await db.insertProjectEntry(entry);
      await _loadEntries();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log entry saved successfully!')),
      );

      _title.clear();
      _description.clear();
      _date.clear();
      _improvement.clear();
    }
  }
  // ✅ END OF UPDATED SECTION

  void _showSuggestionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Weekly Reflection (Optional)"),
        content: TextField(
          controller: _improvement,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: "Write your weekly reflection here...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reflection saved!')),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _goToHomePage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username') ?? 'User';
    final savedEmail = prefs.getString('email') ?? 'user@example.com';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage2(username: savedUsername, email: savedEmail, userId: '',),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmBlue = Color(0xFF005DAA);
    const Color ukmYellow = Color(0xFFF7B500);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Logbook",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
          ),
        ),
        backgroundColor: ukmRed,
        elevation: 4,
        shadowColor: Colors.black38,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ViewProjectEntriesPage()),
            ),
            icon: const Icon(Icons.list_alt),
            tooltip: 'View All Entries',
          ),
          IconButton(
            onPressed: _goToHomePage,
            icon: const Icon(Icons.home),
            tooltip: 'Go to Home Page',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'lib/assets/ukm.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [ukmBlue, ukmRed],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "Add Project Entry",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _date,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    labelStyle: const TextStyle(
                      color: ukmBlue,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: const Icon(Icons.calendar_today, color: ukmRed),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ukmRed, width: 2),
                    ),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _date.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Select a date' : null,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _title,
                  decoration: InputDecoration(
                    labelText: 'Activity',
                    labelStyle: const TextStyle(
                      color: ukmBlue,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: const Icon(Icons.work, color: ukmRed),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ukmRed, width: 2),
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Enter a activty'
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _description,
                  decoration: InputDecoration(
                    labelText: 'Comment (Optional)',
                    labelStyle: const TextStyle(
                      color: ukmBlue,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: const Icon(Icons.comment, color: ukmRed),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ukmRed, width: 2),
                    ),
                  ),
                  validator: (value) => null,
                ),
              ),
              const SizedBox(height: 36),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _showSuggestionDialog,
                  icon: const Icon(Icons.note_alt_outlined),
                  label: const Text('Add Weekly Improvement (Optional)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ukmYellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [ukmRed, Color(0xFFD32F2F)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveLog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text(
                    'Save Log',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: const Center(
                  child: Text(
                    "Universiti Kebangsaan Malaysia",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontSize: 16,
                    ),
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

