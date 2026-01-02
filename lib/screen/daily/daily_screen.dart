import 'package:flutter/material.dart';
import 'package:flutter_training/screen/daily/dailyentry_screen.dart';
import 'package:flutter_training/screen/home_screen.dart';
import 'package:flutter_training/models/logbookentry_models.dart';
import 'package:flutter_training/services/dailydatabase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogbookPage extends StatefulWidget {
  const LogbookPage({super.key});

  @override
  State<LogbookPage> createState() => _LogbookPageState();
}

class _LogbookPageState extends State<LogbookPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _date = TextEditingController();
  final _reflection = TextEditingController();

  List<LogbookEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _date.dispose();
    _reflection.dispose();
    super.dispose();
  }

  // ✅ Load entries for this specific user only
  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) return;

    final entries = await LogbookDatabaseHelper().getLogbookEntries(userId: userId);
    setState(() => _entries = entries);
  }

  // ✅ Save logbook entry with one-entry-per-day restriction per user
  void _saveLog() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found. Please log in again.')),
        );
        return;
      }

      final selectedDate = DateTime.parse(_date.text);
      final db = LogbookDatabaseHelper();

      // Load existing entries for this user only
      final existingEntries = await db.getLogbookEntries(userId: '');

      // Check if user already made an entry today
      final hasEntryToday = existingEntries.any((entry) {
        final entryDate = DateTime.parse(entry.date.toString());
        return entryDate.year == selectedDate.year &&
            entryDate.month == selectedDate.month &&
            entryDate.day == selectedDate.day;
      });

      if (hasEntryToday) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only make one entry per day!')),
        );
        return;
      }

      // Weekly reflection check
      if (_reflection.text.isNotEmpty) {
        final hasWeeklyReflection = existingEntries.any((entry) {
          if (entry.reflection == null || entry.reflection!.isEmpty) return false;
          final entryDate = DateTime.parse(entry.date.toString());
          final difference = selectedDate.difference(entryDate).inDays;
          return difference.abs() < 7;
        });

        if (hasWeeklyReflection) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only add one reflection per week!')),
          );
          return;
        }
      }

      // ✅ Create new logbook entry with userId
      final entry = LogbookEntry(
        title: _title.text,
        description: _description.text.isNotEmpty ? _description.text : '',
        date: DateTime.now(),
        reflection: _reflection.text.isNotEmpty ? _reflection.text : null,
        userId: '',
      );

      await db.insertLogbookEntry(entry);
      await _loadEntries();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log entry saved successfully!')),
      );

      _title.clear();
      _description.clear();
      _date.clear();
      _reflection.clear();
    }
  }

  void _showReflectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Weekly Reflection (Optional)"),
        content: TextField(
          controller: _reflection,
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
              MaterialPageRoute(builder: (_) => const ViewEntriesPage()),
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
              const SizedBox(height: 40),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [ukmBlue, ukmRed],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "Add Logbook Entry",
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

              // 🗓️ Date picker
              _buildTextField(
                controller: _date,
                label: 'Date',
                icon: Icons.calendar_today,
                color: ukmRed,
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
                readOnly: true,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Select a date' : null,
              ),

              const SizedBox(height: 24),

              _buildTextField(
                controller: _title,
                label: 'Activity',
                icon: Icons.work,
                color: ukmRed,
                maxLines: 4,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter an activity' : null,
              ),

              const SizedBox(height: 24),

              _buildTextField(
                controller: _description,
                label: 'Comment (Optional)',
                icon: Icons.comment,
                color: ukmRed,
              ),

              const SizedBox(height: 36),

              ElevatedButton.icon(
                onPressed: _showReflectionDialog,
                icon: const Icon(Icons.note_alt_outlined),
                label: const Text('Add Weekly Reflection (Optional)'),
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
              const Center(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    const Color ukmBlue = Color(0xFF005DAA);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: ukmBlue,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: color),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: color, width: 2),
          ),
        ),
        onTap: onTap,
        validator: validator,
      ),
    );
  }
}
