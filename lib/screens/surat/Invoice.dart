import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class InvoiceGenerator {
  static Future<Uint8List> generateInvoice({
    required String orderNumber,
    required String customerName,
    required String recipientName,
    required String address,
    required String city,
    required String postalCode,
    required String phoneNumber,
    required String orderDate,
    required String courier,
    required List<InvoiceItemData> items,
    required int subtotal,
    required int total,
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
              // Header Company
              _buildHeader(),

              pw.SizedBox(height: 20),

              // Invoice Title & Number
              _buildInvoiceTitle(orderNumber),

              pw.SizedBox(height: 20),

              // Customer Info
              _buildCustomerInfo(
                customerName: recipientName,
                address: address,
                city: city,
                postalCode: postalCode,
                phoneNumber: phoneNumber,
              ),

              pw.SizedBox(height: 20),

              // Invoice Details
              _buildInvoiceDetails(
                invoiceNumber: orderNumber,
                orderNumber: orderNumber,
                orderDate: orderDate,
                courier: courier,
              ),

              pw.SizedBox(height: 20),

              // Items Table
              _buildItemsTable(items),

              pw.SizedBox(height: 20),

              // Total Section
              _buildTotalSection(subtotal: subtotal, total: total),

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

  static pw.Widget _buildHeader() {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'AB Sejahtera',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            '(Supplier Ayam)',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Dsn. Kedawung, Desa Tunggulwulung, Kec.',
            style: const pw.TextStyle(fontSize: 9),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            'Pandaan, Pasuruan, Jawa Timur 67156',
            style: const pw.TextStyle(fontSize: 9),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            'Tel: 085655842030',
            style: const pw.TextStyle(fontSize: 9),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            'absejahtera@gmail.com',
            style: const pw.TextStyle(fontSize: 9),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInvoiceTitle(String orderNumber) {
    return pw.Column(
      children: [
        pw.Center(
          child: pw.Text(
            'INVOICE',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Center(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(width: 1)),
            ),
            child: pw.Text(
              'INV-AB/$orderNumber',
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildCustomerInfo({
    required String customerName,
    required String address,
    required String city,
    required String postalCode,
    required String phoneNumber,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(width: 1)),
          ),
          child: pw.Text(
            'TAGIHAN KEPADA:',
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          customerName,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Text(address, style: const pw.TextStyle(fontSize: 9)),
        pw.Text('$city, $postalCode', style: const pw.TextStyle(fontSize: 9)),
        pw.Text(phoneNumber, style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  static pw.Widget _buildInvoiceDetails({
    required String invoiceNumber,
    required String orderNumber,
    required String orderDate,
    required String courier,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(width: 1),
          bottom: pw.BorderSide(width: 1),
        ),
      ),
      child: pw.Column(
        children: [
          _buildDetailRow('No. Invoice:', 'INV-AB/$invoiceNumber'),
          pw.SizedBox(height: 3),
          _buildDetailRow('No. Pesanan:', 'AB/$orderNumber'),
          pw.SizedBox(height: 3),
          _buildDetailRow('Tanggal:', orderDate),
          pw.SizedBox(height: 3),
          _buildDetailRow('Kurir:', courier),
        ],
      ),
    );
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Container(
          width: 100,
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  static pw.Widget _buildItemsTable(List<InvoiceItemData> items) {
    return pw.Column(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(width: 1)),
          ),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 5,
                child: pw.Text(
                  'Item',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: 60,
                child: pw.Text(
                  'Qty',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: 100,
                child: pw.Text(
                  'Total',
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
        ...items.map(
          (item) => pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
              ),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 5,
                      child: pw.Text(
                        item.productName,
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 60,
                      child: pw.Text(
                        item.quantity.toString(),
                        style: const pw.TextStyle(fontSize: 9),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Container(
                      width: 100,
                      child: pw.Text(
                        _formatRupiah(item.totalPrice),
                        style: const pw.TextStyle(fontSize: 9),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  _formatRupiah(item.unitPrice),
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTotalSection({
    required int subtotal,
    required int total,
  }) {
    return pw.Column(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(width: 1),
              bottom: pw.BorderSide(width: 1),
            ),
          ),
          child: pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Subtotal: ${_formatRupiah(subtotal)}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'TOTAL:',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              _formatRupiah(total),
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(width: 1)),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.SizedBox(height: 12),
        pw.Center(
          child: pw.Text(
            'Terima kasih atas kepercayaan Anda!',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 1),
        pw.SizedBox(height: 4),
        pw.Center(
          child: pw.Text(
            'Dicetak: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
          ),
        ),
      ],
    );
  }

  static String _formatRupiah(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Helper function untuk print invoice
  static Future<void> printInvoice({
    required String orderNumber,
    required String customerName,
    required String recipientName,
    required String address,
    required String city,
    required String postalCode,
    required String phoneNumber,
    required String orderDate,
    required String courier,
    required List<InvoiceItemData> items,
    required int subtotal,
    required int total,
    String? notes,
  }) async {
    final pdfData = await generateInvoice(
      orderNumber: orderNumber,
      customerName: customerName,
      recipientName: recipientName,
      address: address,
      city: city,
      postalCode: postalCode,
      phoneNumber: phoneNumber,
      orderDate: orderDate,
      courier: courier,
      items: items,
      subtotal: subtotal,
      total: total,
      notes: notes,
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }
}

// Model class untuk invoice items
class InvoiceItemData {
  final String productName;
  final int quantity;
  final int unitPrice;
  final int totalPrice;

  InvoiceItemData({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
}
