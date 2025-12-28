import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../services/storage_service.dart';

class ExportService {
  static Future<void> exportUserData(String userName) async {
    final records = await StorageService.getRecordsByUser(userName);
    if (records.isEmpty) {
      throw Exception('No hay registros para exportar');
    }

    // Crear PDF
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Reporte de IMC - $userName',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Generado el: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Fecha',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Peso (kg)',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Altura (cm)',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'IMC',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Categoría',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...records.map((record) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(dateFormat.format(record.fecha)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(record.peso.toStringAsFixed(1)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          (record.altura * 100).toStringAsFixed(0),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(record.imc.toStringAsFixed(1)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(record.categoria),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ];
        },
      ),
    );

    // Guardar PDF
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/imc_${userName}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());

    // Compartir
    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Reporte de IMC de $userName');
  }

  static Future<void> exportAllData() async {
    final records = await StorageService.getRecords();
    if (records.isEmpty) {
      throw Exception('No hay registros para exportar');
    }

    // Crear CSV
    final csv = StringBuffer();
    csv.writeln(
      'Usuario,Fecha,Peso (kg),Altura (cm),Edad,Género,IMC,Categoría',
    );

    for (final record in records) {
      final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
      csv.writeln(
        '${record.userName},'
        '${dateFormat.format(record.fecha)},'
        '${record.peso},'
        '${(record.altura * 100).toStringAsFixed(0)},'
        '${record.edad},'
        '${record.genero},'
        '${record.imc.toStringAsFixed(1)},'
        '${record.categoria}',
      );
    }

    // Guardar CSV
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/imc_all_data_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(csv.toString());

    // Compartir
    await Share.shareXFiles([XFile(file.path)], text: 'Datos completos de IMC');
  }
}
