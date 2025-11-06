import 'package:flutter/material.dart';

class Detailpesanan extends StatelessWidget {
  const Detailpesanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
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
                  "Selamat Datang",
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Padding(
              padding: const EdgeInsets.only(top: 31, left: 28),
              child: Row(
                children: const [
                  Text(
                    "Pesanan",
                    style: TextStyle(
                      fontFamily: "Primary",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.chevron_right, color: Colors.grey),
                  SizedBox(width: 3),
                  Text(
                    "Detail",
                    style: TextStyle(
                      fontFamily: "Primary",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tombol atas (Invoice, Surat Jalan, Edit)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Invoice",
                      style: TextStyle(
                        fontFamily: "Primary",
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Surat Jalan",
                      style: TextStyle(
                        fontFamily: "Primary",
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF26D2B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Edit Pesanan",
                      style: TextStyle(
                        fontFamily: "Primary",
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section: Detail Pesanan
            const DetailSection(),

            // Section: Item Pesanan
            const ItemSection(),

            // Section: Riwayat Status
            const RiwayatSection(),
          ],
        ),
      ),
    );
  }
}

class DetailSection extends StatelessWidget {
  const DetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    final labelStyle = const TextStyle(
      fontFamily: "Primary",
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: Colors.black54,
    );

    final valueStyle = const TextStyle(
      fontFamily: "Primary",
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: Colors.black,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detail Pesanan",
                style: TextStyle(
                  fontFamily: "Primary",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              LayoutBuilder(
                builder: (context, constraints) {
                  final halfWidth = (constraints.maxWidth - 16) / 2;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 👉 Kolom kiri
                      SizedBox(
                        width: halfWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoItem(
                              "Nomor Pesanan",
                              "AB/28092025/0051",
                              labelStyle,
                              valueStyle,
                            ),
                            _infoItem(
                              "Kurir",
                              "Syaroni",
                              labelStyle,
                              valueStyle,
                            ),
                            _infoItem(
                              "Alamat",
                              "Pandan",
                              labelStyle,
                              valueStyle,
                            ),
                            _infoItem(
                              "Tanggal Pesanan",
                              "28 Sep 2025",
                              labelStyle,
                              valueStyle,
                            ),
                            _infoItem(
                              "Status Pembayaran",
                              "Menunggu",
                              labelStyle,
                              valueStyle.copyWith(color: Colors.orange),
                            ),
                            _infoItem(
                              "Sisa Belum Dibayar",
                              "Rp 360.000",
                              labelStyle,
                              valueStyle,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Kolom kanan
                      SizedBox(
                        width: halfWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoItem(
                              "Pelanggan",
                              "Limin",
                              labelStyle,
                              valueStyle,
                            ),
                            _infoItem(
                              "Nama Penerima",
                              "Limin",
                              labelStyle,
                              valueStyle,
                            ),
                            _infoItem(
                              "Kota",
                              "Pasuruan",
                              labelStyle,
                              valueStyle,
                            ),
                            _infoItem(
                              "Total Harga",
                              "Rp 360.000",
                              labelStyle,
                              valueStyle,
                            ),
                            _infoItem(
                              "Jumlah Teralokasi",
                              "Rp 0",
                              labelStyle,
                              valueStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(height: 4),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}

class ItemSection extends StatelessWidget {
  const ItemSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Item Pesanan",
                style: TextStyle(
                  fontFamily: "Primary",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Expanded(child: Text("Produk", style: _headerStyle)),
                  Expanded(child: Text("Jumlah", style: _headerStyle)),
                  Expanded(child: Text("Harga Satuan", style: _headerStyle)),
                  Expanded(child: Text("Subtotal", style: _headerStyle)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      "Ayam 065C ons",
                      style: TextStyle(
                        fontFamily: "Primary",
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "10",
                      style: TextStyle(
                        fontFamily: "Primary",
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Rp 36.000",
                      style: TextStyle(
                        fontFamily: "Primary",
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Rp 360.000",
                      style: TextStyle(
                        fontFamily: "Primary",
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _headerStyle = TextStyle(
  fontFamily: "Primary",
  fontWeight: FontWeight.w600,
  fontSize: 10,
);

class RiwayatSection extends StatelessWidget {
  const RiwayatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _riwayatTitle(context),
              const SizedBox(height: 12),

              _StatusCard(
                status: "Menunggu",
                active: true,
                catatan: "Order updated via API",
                waktu: "Sep 28, 2025 22:12",
              ),

              _StatusCard(
                status: "Menunggu",
                active: false,
                catatan: "Order created via API",
                waktu: "Sep 28, 2025 22:12",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _riwayatTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Riwayat Status",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffF26D2B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          ),
          child: const Text(
            "Ubah Status",
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Primary",
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String status;
  final bool active;
  final String catatan;
  final String waktu;

  const _StatusCard({
    required this.status,
    required this.active,
    required this.catatan,
    required this.waktu,
  });

  /// ROW LINE
  Widget _row(String title, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                fontFamily: "Primary",
              ),
            ),
          ),
          Expanded(child: value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// STATUS (text biasa)
        _row(
          "Status",
          Text(
            status,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              fontFamily: "Primary",
              color: Colors.orange,
            ),
          ),
        ),

        /// AKTIF (icon kiri, tidak center)
        _row(
          "Aktif",
          Row(
            children: [
              Icon(
                active ? Icons.check_circle : Icons.cancel,
                color: active ? Colors.green : Colors.red,
                size: 18,
              ),
            ],
          ),
        ),

        /// CATATAN
        _row(
          "Catatan",
          Text(
            catatan,
            style: const TextStyle(fontSize: 13, fontFamily: "Primary"),
          ),
        ),

        /// WAKTU
        _row(
          "Waktu",
          Text(
            waktu,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: "Primary",
            ),
          ),
        ),

        const SizedBox(height: 12),
        Divider(color: Colors.grey.shade300, thickness: 1, height: 20),
      ],
    );
  }
}
