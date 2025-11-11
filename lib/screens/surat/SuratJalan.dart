import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class DeliveryNoteGenerator {
  static Future<Uint8List> generateDeliveryNote({
    required String orderNumber,
    required String customerName,
    required String recipientName,
    required String address,
    required String city,
    required String postalCode,
    required String orderDate,
    required String deliveryDate,
    required String courier,
    required List<OrderItemData> items,
    String? notes,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header dengan info customer di kanan
              _buildHeader(
                orderNumber: orderNumber,
                recipientName: recipientName,
                customerName: customerName,
                address: address,
                city: city,
                postalCode: postalCode,
              ),

              pw.SizedBox(height: 16),
              pw.Divider(thickness: 1.5),
              pw.SizedBox(height: 12),

              // Order Info (compact)
              _buildOrderInfo(
                orderNumber: orderNumber,
                orderDate: orderDate,
                deliveryDate: deliveryDate,
                courier: courier,
              ),

              pw.SizedBox(height: 16),

              // Items Table
              _buildItemsTable(items),

              pw.SizedBox(height: 16),

              // Status Pengiriman
              _buildStatusSection(),

              pw.SizedBox(height: 16),

              // Notes Section
              if (notes != null && notes.isNotEmpty) _buildNotes(notes),

              pw.Spacer(),

              // Footer
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader({
    required String orderNumber,
    required String recipientName,
    required String customerName,
    required String address,
    required String city,
    required String postalCode,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        // Company Info (kiri)
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'AB Sejahtera',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '(Supplier Ayam)',
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              'Dsn. Kedawung, Desa Tunggulwulung, Kec.',
              style: const pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              'Pandaan, Pasuruan, Jawa Timur 67156',
              style: const pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              'Tel: 085655842030',
              style: const pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              'absejahtera@gmail.com',
              style: const pw.TextStyle(fontSize: 8),
            ),
            pw.SizedBox(height: 12),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 40,
              ),
              decoration: pw.BoxDecoration(border: pw.Border.all(width: 1.5)),
              child: pw.Text(
                'SURAT JALAN',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              'SJ-AB/$orderNumber',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),

        // Customer Info (kanan)
        pw.Container(
          width: 220,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'PENGIRIMAN KEPADA:',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                recipientName,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (customerName != recipientName) ...[
                pw.SizedBox(height: 2),
                pw.Text(customerName, style: const pw.TextStyle(fontSize: 9)),
              ],
              pw.SizedBox(height: 2),
              pw.Text(address, style: const pw.TextStyle(fontSize: 9)),
              pw.Text(
                'Tel: ${postalCode}',
                style: const pw.TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildOrderInfo({
    required String orderNumber,
    required String orderDate,
    required String deliveryDate,
    required String courier,
  }) {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildInfoRow('No. Surat Jalan:', 'SJ-AB/$orderNumber'),
            ),
            pw.SizedBox(width: 20),
            pw.Expanded(
              child: _buildInfoRow('No. Pesanan:', 'AB/$orderNumber'),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          children: [
            pw.Expanded(child: _buildInfoRow('Tgl Pesanan:', orderDate)),
            pw.SizedBox(width: 20),
            pw.Expanded(child: _buildInfoRow('Tgl Kirim:', deliveryDate)),
          ],
        ),
        pw.SizedBox(height: 4),
        _buildInfoRow('Kurir:', courier),
      ],
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Container(
          width: 120,
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  static pw.Widget _buildItemsTable(List<OrderItemData> items) {
    return pw.Column(
      children: [
        // Header
        pw.Container(
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(width: 1.5),
              bottom: pw.BorderSide(width: 1.5),
            ),
          ),
          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 5,
                child: pw.Text(
                  'Barang',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: 80,
                child: pw.Text(
                  'Qty',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ),

        // Items
        ...items.map(
          (item) => pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 5,
                  child: pw.Text(
                    item.productName,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
                pw.Container(
                  width: 80,
                  child: pw.Text(
                    item.quantity.toString(),
                    style: const pw.TextStyle(fontSize: 9),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Total
        pw.Container(
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(width: 1.5)),
          ),
          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Total Item: ${items.length} jenis',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Total Kuantitas: ${items.fold<int>(0, (sum, item) => sum + item.quantity)} pcs',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildStatusSection() {
    final now = DateTime.now();
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'STATUS PENGIRIMAN:',
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          _buildStatusRow('Status:', 'Menunggu'),
          pw.SizedBox(height: 3),
          _buildStatusRow('Catatan:', 'Order created via API'),
          pw.SizedBox(height: 3),
          _buildStatusRow(
            'Update:',
            DateFormat('dd/MM/yyyy HH:mm').format(now),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStatusRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 80,
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 8)),
        ),
        pw.Expanded(
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 8)),
        ),
      ],
    );
  }

  static pw.Widget _buildNotes(String notes) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'CATATAN PENGIRIMAN:',
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(notes, style: const pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(thickness: 1.5),
        pw.SizedBox(height: 8),
        pw.Text(
          'Dicetak: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 3),
        pw.Divider(thickness: 1.5),
        pw.SizedBox(height: 3),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildSignatureBox('Pengirim'),
            _buildSignatureBox('Penerima'),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Dokumen ini sah tanpa tanda tangan basah',
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  static pw.Widget _buildSignatureBox(String label) {
    return pw.Container(
      width: 160,
      child: pw.Column(
        children: [
          pw.Container(height: 1, width: 120, color: PdfColors.black),
          pw.SizedBox(height: 3),
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper function to show print dialog
  static Future<void> printDeliveryNote({
    required String orderNumber,
    required String customerName,
    required String recipientName,
    required String address,
    required String city,
    required String postalCode,
    required String orderDate,
    required String deliveryDate,
    required String courier,
    required List<OrderItemData> items,
    String? notes,
  }) async {
    final pdfData = await generateDeliveryNote(
      orderNumber: orderNumber,
      customerName: customerName,
      recipientName: recipientName,
      address: address,
      city: city,
      postalCode: postalCode,
      orderDate: orderDate,
      deliveryDate: deliveryDate,
      courier: courier,
      items: items,
      notes: notes,
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }
}

// Model class for order items
class OrderItemData {
  final String productName;
  final int quantity;

  OrderItemData({required this.productName, required this.quantity});
}
