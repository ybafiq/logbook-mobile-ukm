import 'package:flutter/material.dart';
import 'package:logbook_ukm/models/projectentry_models.dart';

class ViewSingleProjectEntryPage extends StatelessWidget {
  final ProjectEntry entry;

  const ViewSingleProjectEntryPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmBlue = Color(0xFF005DAA);
    const Color ukmLightBlue = Color(0xFFE3F2FD); // Subtle light blue for background

    return Scaffold(
      backgroundColor: Colors.white, // Synchronized background
      appBar: AppBar(
        title: const Text(
          "View Project Entry",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500, // Adjusted for minimalism
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true, // Centered title
        backgroundColor: ukmRed,
        elevation: 0, // Minimal elevation
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 1, // Reduced elevation for subtlety
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Softer corners
              ),
              color: ukmLightBlue,
              child: Padding(
                padding: const EdgeInsets.all(24), // Generous padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Minimize height
                  children: [
                    // Date header with subtle styling
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            color: ukmBlue.withOpacity(0.8), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          entry.date,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ukmBlue.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Activity section
                    Text(
                      "Activity",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ukmRed.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.title,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5, // Better line height for readability
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Comment section
                    Text(
                      "Comment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ukmRed.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.activity,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),

                    if (entry.improvement != null &&
                        entry.improvement!.isNotEmpty) ...[
                      const SizedBox(height: 24),

                      // Improvement section
                      Text(
                        "Improvement",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ukmRed.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.improvement!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Back button (centered, minimal)
                    Align(
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: ukmBlue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

