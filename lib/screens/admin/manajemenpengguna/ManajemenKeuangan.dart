import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controller/users_controller.dart';

class ManajemenKeuangan extends StatefulWidget {
  const ManajemenKeuangan({super.key});

  @override
  State<ManajemenKeuangan> createState() => _ManajemenKeuanganState();
}

class _ManajemenKeuanganState extends State<ManajemenKeuangan> {
  final UserController controller = Get.put(UserController());
  final box = GetStorage();
  int? userId;

  @override
  void initState() {
    super.initState();
    //ambil user id
    final args = Get.arguments;
    if (args != null && args['userId'] != null) {
      userId = args['userId'];
    } else {
      userId = box.read('user_id') ?? box.read('id');
    }

    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getUserBalance(userId!);
        controller.getUserDetail(userId!);
      });
    } else {
      // Tampilkan pesan error jika user ID tidak ditemukan
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Error',
          'User ID tidak ditemukan. Silakan login kembali.',
          snackPosition: SnackPosition.TOP,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          if (userId != null) {
            await controller.getUserBalance(userId!);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
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
        InkWell(
          onTap: () => _showTopUpDialog(),
          child: Container(
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
        ),
      ],
    );
  }

  Widget _buildSaldoCards() {
    return Obx(() {
      if (controller.isLoadingBalance.value) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            child: const CircularProgressIndicator(),
          ),
        );
      }

      final balance = controller.userBalance.value;

      return Row(
        children: [
          Expanded(
            child: _SaldoCard(
              amount: balance?.formattedCurrentBalance ?? "Rp 0",
              label: "Saldo Saat Ini",
              subtitle: "Total Saldo Customer",
              color: const Color.fromARGB(255, 82, 144, 195),
              textColor: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SaldoCard(
              amount: balance?.formattedReservedBalance ?? "Rp 0",
              label: "Total Piutang",
              subtitle: "Pesanan yang belum terbayar",
              color: Colors.red[200]!,
              textColor: Colors.white,
            ),
          ),
        ],
      );
    });
  }

  //dialog top up
  void _showTopUpDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // Ambil nama user dari controller
    final userName = controller.userDetail.value?.name ?? "User";
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: Get.width * 0.9,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - DINAMIS BERDASARKAN USER
                Text(
                  "Isi Ulang Saldo - $userName",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Primary",
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Tambahkan Saldo Untuk Customer Ini",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Primary",
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // Jumlah Top up
                Row(
                  children: [
                    const Text(
                      "Jumlah Top up",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Primary",
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "*wajib diisi",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Primary",
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Input Nominal
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Rp",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontFamily: "Primary",
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xff009BEE)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah harus diisi';
                    }
                    final amount = double.tryParse(
                      value.replaceAll('.', '').replaceAll(',', ''),
                    );
                    if (amount == null) {
                      return 'Jumlah tidak valid';
                    }
                    if (amount < 1000) {
                      return 'Minimal Rp 1.000';
                    }
                    if (amount > 50000000) {
                      return 'Maksimal Rp 50.000.000';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Format ribuan
                    if (value.isNotEmpty) {
                      String cleanValue = value.replaceAll('.', '');
                      if (cleanValue.isNotEmpty) {
                        final number = int.tryParse(cleanValue);
                        if (number != null) {
                          final formatter = NumberFormat('#,###', 'id_ID');
                          String formatted = formatter.format(number);
                          amountController.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                              offset: formatted.length,
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  "Minimal Rp 1.000 Maximal Rp 50.000.000",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Primary",
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Catatan
                const Text(
                  "Catatan",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Primary",
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // Input Catatan
                TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Tambahkan catatan (opsional)",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontFamily: "Primary",
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xff009BEE)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    // Tombol Kirim (Hijau)
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isSubmitting.value
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    final cleanAmount = amountController.text
                                        .replaceAll('.', '')
                                        .replaceAll(',', '');
                                    final amount = double.parse(cleanAmount);

                                    controller.topUpBalance(
                                      userId: userId!,
                                      amount: amount,
                                      description:
                                          descriptionController.text.isEmpty
                                          ? null
                                          : descriptionController.text,
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                          child: controller.isSubmitting.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Kirim",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Primary",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Tombol Batal (Abu-abu)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "Primary",
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
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
