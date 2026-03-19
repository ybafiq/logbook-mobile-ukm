import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BagwormDetectionPage extends StatefulWidget {
  const BagwormDetectionPage({super.key});

  @override
  State<BagwormDetectionPage> createState() => _BagwormDetectionPageState();
}

class _BagwormDetectionPageState extends State<BagwormDetectionPage> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((x) => File(x.path)));
      });
    }
  }

  Future<void> _takePhoto() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _images.add(File(picked.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color fgvOrange = Color(0xFFF57C00);
    const Color fgvDark = Color(0xFF333333);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'lib/assets/fgv.png', // your logo
              height: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'Bagworm Detection',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟠 Info box
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: fgvOrange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Upload multiple images of the same tree from different angles to detect bagworm infestations.\nSupported formats: JPG, PNG, WebP',
                      style: TextStyle(color: fgvDark, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              'Upload Images',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: fgvDark,
              ),
            ),
            const SizedBox(height: 15),

            // 🟧 Upload area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange.shade200, width: 2, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
                color: Colors.orange[50],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_outlined, color: fgvOrange, size: 50),
                  const SizedBox(height: 10),
                  const Text(
                    'Upload images to detect bagworms',
                    style: TextStyle(color: fgvDark, fontSize: 14),
                  ),
                  const Text(
                    'PNG, JPG, WebP up to 10MB each',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImages,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: fgvOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.file_upload, color: Colors.white),
                        label: const Text('Choose Files',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: _takePhoto,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: fgvDark),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.camera_alt, color: fgvDark),
                        label: const Text('Take Photo',
                            style: TextStyle(color: fgvDark)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 📸 Preview section
            if (_images.isNotEmpty) ...[
              const SizedBox(height: 25),
              const Text(
                'Selected Images:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _images
                    .map((img) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(img,
                              height: 80, width: 80, fit: BoxFit.cover),
                        ))
                    .toList(),
              ),
            ],

            const SizedBox(height: 40),

            // Footer
            Center(
              child: Column(
                children: const [
                  Divider(thickness: 0.3, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    '© 2025 FGV R&D Sdn Bhd. All rights reserved.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

