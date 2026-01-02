import 'package:flutter_training/models/logbookentry_models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generatePdf(
  List<LogbookEntry> entries, {
  required String username,
  required String matricno,
  required String workplace,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) => [
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                'STBC4866 LATIHAN TEMPAT KERJA BIOINFORMATIK',
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Templat Buku Log / Student’s Logbook Template',
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.Text(
                '(Untuk disemak oleh penyelia industri pada setiap tiga minggu)',
                style: const pw.TextStyle(fontSize: 9),
              ),
              pw.SizedBox(height: 20),
            ],
          ),
        ),

        // Student Info Section
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Nama Pelajar / Name of Student: $username'),
              pw.Text('No. Pendaftaran / Matric No.: $matricno'),
              pw.Text('Tempat Latihan / Working Place: $workplace'),
            ],
          ),
        ),
        pw.SizedBox(height: 20),

        // Logbook Table
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.5),
            1: const pw.FlexColumnWidth(3),
            2: const pw.FlexColumnWidth(2.5),
          },
          children: [
            pw.TableRow(
              decoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text('Tarikh / Date',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text('Aktiviti / Activity',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text('Komen / Comment',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...entries.map(
              (entry) => pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(entry.date.toString().split(' ')[0]),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(entry.description),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(entry.comment ?? '-'),
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 25),

        // Weekly Reflection
        pw.Text(
          'Refleksi Mingguan / Weekly Reflection:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Container(
          height: 80,
          margin: const pw.EdgeInsets.only(top: 8),
          decoration:
              pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),
        ),

        pw.SizedBox(height: 30),

        // Supervisor Section
        pw.Text(
          'Cop dan tandatangan penyelia industri (setiap 3 minggu) / '
          'Industry supervisor’s cop and signature (every 3 weeks):',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 60),
        pw.Text('Tarikh / Date: __________________________'),
        pw.SizedBox(height: 15),
        pw.Text('Komen / Comments:'),
        pw.Container(
          height: 60,
          margin: const pw.EdgeInsets.only(top: 8),
          decoration:
              pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),
        ),
      ],
    ),
  );

  await Printing.sharePdf(bytes: await pdf.save(), filename: 'logbook.pdf');
}
