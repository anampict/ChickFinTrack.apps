import 'package:flutter/material.dart';

class ManajemenKeuangan extends StatelessWidget {
  const ManajemenKeuangan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDashboardTitle(),
              const SizedBox(height: 16),
              _buildSaldoCards(),
              const SizedBox(height: 24),
              _buildKreditPesananSection(),
              const SizedBox(height: 24),
              _buildRiwayatTransaksiSection(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/image.png"),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Selamat Malam",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontFamily: "Primary",
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "Admin RPA",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 9,
                  fontFamily: "Primary",
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mail, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xffF26D2B),
              shape: const CircleBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Dashboard Keuangan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: const [
              Icon(Icons.wallet, color: Colors.white, size: 14),
              SizedBox(width: 4),
              Text(
                "Top - Up Saldo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaldoCards() {
    return Row(
      children: [
        Expanded(
          child: _SaldoCard(
            amount: "Rp 1.000.000",
            label: "Saldo Saat Ini",
            subtitle: "Total Saldo Customer",
            color: const Color.fromARGB(255, 82, 144, 195),
            textColor: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SaldoCard(
            amount: "Rp 2.000.000",
            label: "Total Piutang",
            subtitle: "Pesanan yang belum terbayar",
            color: Colors.red[100]!,
            textColor: Colors.red[700]!,
          ),
        ),
      ],
    );
  }

  Widget _buildKreditPesananSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "List Kredit Pesanan",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: "cari id pesanan",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        _KreditPesananCard(
          nomorPesanan: "#AB/23102025/0153",
          tanggal: "23/10 12:47",
          totalKredit: "Rp 460.000",
          teralokasi: "Rp 1.000.000",
          sisa: "Rp 480.000",
          sisaColor: Colors.orange,
        ),
        const SizedBox(height: 12),
        _KreditPesananCard(
          nomorPesanan: "#AB/23102025/0153",
          tanggal: "23/10 12:47",
          totalKredit: "Rp 1.460.000",
          teralokasi: "Rp 1.000.000",
          sisa: "Rp 460.000",
          sisaColor: Colors.red,
        ),
        const SizedBox(height: 12),
        _KreditPesananCard(
          nomorPesanan: "#AB/23102025/0153",
          tanggal: "",
          totalKredit: "",
          teralokasi: "Rp 1.000.000",
          sisa: "",
          sisaColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildRiwayatTransaksiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Riwayat Transaksi",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        _RiwayatTransaksiCard(
          tanggal: "23/10 12:47",
          jenis: "Bayar Ayam 05 ons",
          saldo: "Rp 460.000",
          keterangan: "Bayar Ayam 05 ons",
          isDebit: false,
        ),
      ],
    );
  }
}

// Widget terpisah untuk Saldo Card
class _SaldoCard extends StatelessWidget {
  final String amount;
  final String label;
  final String subtitle;
  final Color color;
  final Color textColor;

  const _SaldoCard({
    required this.amount,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}

// Widget terpisah untuk Kredit Pesanan Card
class _KreditPesananCard extends StatelessWidget {
  final String nomorPesanan;
  final String tanggal;
  final String totalKredit;
  final String teralokasi;
  final String sisa;
  final Color sisaColor;
  final String status; // Tambahkan parameter status
  final Color statusColor; // Warna background status
  final Color statusTextColor; // Warna text status

  const _KreditPesananCard({
    required this.nomorPesanan,
    required this.tanggal,
    required this.totalKredit,
    required this.teralokasi,
    required this.sisa,
    required this.sisaColor,
    this.status = "Sisa", // Default status
    this.statusColor = const Color(0xFFE3F2FD), // Default background biru muda
    this.statusTextColor = const Color(0xFF1565C0), // Default text biru tua
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Nomor pesanan", nomorPesanan),
                    if (tanggal.isNotEmpty) const SizedBox(height: 8),
                    if (tanggal.isNotEmpty) _buildInfoRow("Tanggal", tanggal),
                    if (totalKredit.isNotEmpty) const SizedBox(height: 8),
                    if (totalKredit.isNotEmpty)
                      _buildInfoRow(
                        "Total Kredit",
                        totalKredit,
                        valueColor: Colors.black,
                        isBold: true,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Teralokasi", teralokasi),
                    if (sisa.isNotEmpty) const SizedBox(height: 8),
                    if (sisa.isNotEmpty)
                      _buildInfoRow(
                        "Sisa",
                        sisa,
                        valueColor: sisaColor,
                        isBold: true,
                      ),
                    const SizedBox(height: 8),
                    _buildInfoRow("Status", ""),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          color: statusTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      size: 14, // kecilkan agar proporsional
                    ),
                    label: const Text(
                      "Alokasi",
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4DD0E1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4, // atur agar total tinggi sekitar 20
                      ),
                      minimumSize: const Size(0, 20), // tinggi tombol jadi 20
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.check_circle,
                      size: 14, // kecilkan agar proporsional
                    ),
                    label: const Text(
                      "Bayar Penuh",
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff55BC10),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4, // atur agar total tinggi sekitar 20
                      ),
                      minimumSize: const Size(0, 20), // tinggi tombol jadi 20
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        if (value.isNotEmpty) const SizedBox(height: 2),
        if (value.isNotEmpty)
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: valueColor ?? Colors.black,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
      ],
    );
  }
}

// Widget terpisah untuk Riwayat Transaksi Card
class _RiwayatTransaksiCard extends StatelessWidget {
  final String tanggal;
  final String jenis;
  final String saldo;
  final String keterangan;
  final bool isDebit;

  const _RiwayatTransaksiCard({
    required this.tanggal,
    required this.jenis,
    required this.saldo,
    required this.keterangan,
    required this.isDebit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("Tanggal", tanggal),
                const SizedBox(height: 8),
                _buildInfoRow("Jenis", jenis),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("Saldo", ""),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isDebit ? "Debit" : "Kredit",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow("Keterangan", keterangan),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 20),
              Text(
                "Jumlah",
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                saldo,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        if (value.isNotEmpty) const SizedBox(height: 2),
        if (value.isNotEmpty)
          Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
      ],
    );
  }
}
