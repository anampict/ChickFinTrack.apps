import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controller/users_controller.dart';
import 'package:my_app/data/models/credit_model.dart';

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
        controller.getUserCredits(userId!).then((_) {});
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
            child: Obx(() {
              // Hitung total piutang dari credits
              final totalPiutang = controller.userCredits
                  .where((credit) => credit.status.toLowerCase() != 'paid')
                  .fold(0.0, (sum, credit) {
                    final remaining =
                        double.tryParse(credit.remainingAmount) ?? 0;
                    return sum + remaining;
                  });

              final formattedPiutang =
                  'Rp ${totalPiutang.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

              return _SaldoCard(
                amount: formattedPiutang,
                label: "Total Piutang",
                subtitle: "Pesanan Yang Belum Terbayar",
                color: Colors.red[200]!,
                textColor: Colors.white,
              );
            }),
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
            child: SingleChildScrollView(
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
                  const SizedBox(height: 20),

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
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildKreditPesananSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "List Kredit Pesanan",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              if (controller.totalCredits.value > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.totalCredits.value} Kredit',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[800],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Search field
          TextField(
            onChanged: (value) => _filterCredits(value),
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

          // Loading state
          if (controller.isLoadingCredits.value)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
          // Empty state
          else if (controller.userCredits.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.credit_card_off,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada data kredit',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          // Credit list
          else
            Column(
              children: [
                // 🔥 Filter hanya yang remaining > 0 atau tampilkan semua dengan status berbeda
                ...controller.userCredits.map((credit) {
                  final remaining =
                      double.tryParse(credit.remainingAmount) ?? 0;
                  final isLunas =
                      remaining <= 0 || credit.status.toLowerCase() == 'paid';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _KreditPesananCard(
                      credit: credit,
                      isLunas: isLunas, // 🔥 Pass status lunas
                      onAlokasi: isLunas
                          ? () {
                              // Tampilkan info jika sudah lunas
                              Get.snackbar(
                                'Info',
                                'Kredit ini sudah lunas',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.blue,
                                colorText: Colors.white,
                              );
                            }
                          : () => _showAlokasiDialog(credit),
                      onBayarPenuh: isLunas
                          ? () {
                              Get.snackbar(
                                'Info',
                                'Kredit ini sudah lunas',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.blue,
                                colorText: Colors.white,
                              );
                            }
                          : () => _showBayarPenuhDialog(credit),
                    ),
                  );
                }).toList(),

                // Load more button
                if (controller.creditCurrentPage.value <
                    controller.creditLastPage.value)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: controller.isLoadMoreCredits.value
                        ? const Center(child: CircularProgressIndicator())
                        : TextButton(
                            onPressed: () {
                              if (userId != null) {
                                controller.loadMoreCredits(userId!);
                              }
                            },
                            child: const Text('Muat Lebih Banyak'),
                          ),
                  ),
              ],
            ),
        ],
      );
    });
  }

  // Filter credits berdasarkan search
  void _filterCredits(String query) {
    // TODO: Implement search filter jika diperlukan
    // Bisa menggunakan .where() untuk filter userCredits
  }

  // Dialog untuk alokasi
  void _showAlokasiDialog(CreditModel credit) {
    if (userId == null) {
      Get.snackbar(
        'Error',
        'User ID tidak ditemukan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 🔥 Validasi awal - cek remaining
    final remaining = double.tryParse(credit.remainingAmount) ?? 0;
    if (remaining <= 0) {
      Get.snackbar(
        'Info',
        'Kredit ini sudah lunas',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      return;
    }

    // 🔥 Cek status
    if (credit.status.toLowerCase() == 'paid') {
      Get.snackbar(
        'Info',
        'Kredit ini sudah lunas',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      return;
    }

    final amountController = TextEditingController();
    final descriptionController = TextEditingController(text: 'bayar');
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Alokasi Kredit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              credit.order?.orderNumber ?? "-",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info saldo tersedia
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saldo Tersedia:',
                          style: TextStyle(fontSize: 13),
                        ),
                        Obx(
                          () => Text(
                            controller
                                    .userBalance
                                    .value
                                    ?.formattedAvailableBalance ??
                                'Rp 0',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sisa Kredit:',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          credit.formattedRemainingAmount,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Input jumlah
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Alokasi',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan jumlah',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus diisi';
                  }
                  final amount = double.tryParse(
                    value.replaceAll('.', '').replaceAll(',', ''),
                  );
                  if (amount == null || amount <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }

                  // Validasi: tidak boleh melebihi sisa kredit
                  if (amount > remaining) {
                    return 'Jumlah melebihi sisa kredit (max: Rp ${remaining.toStringAsFixed(0)})';
                  }

                  // Validasi: tidak boleh melebihi saldo tersedia
                  final availableBalance =
                      double.tryParse(
                        controller.userBalance.value?.availableBalance ?? '0',
                      ) ??
                      0;
                  if (amount > availableBalance) {
                    return 'Saldo tidak mencukupi';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input keterangan
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan',
                  border: OutlineInputBorder(),
                  hintText: 'Contoh: bayar',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isSubmitting.value
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        final amount = double.parse(
                          amountController.text
                              .replaceAll('.', '')
                              .replaceAll(',', ''),
                        );

                        // 🔥 Double check sebelum submit
                        if (amount > remaining) {
                          Get.snackbar(
                            'Error',
                            'Jumlah melebihi sisa kredit',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        controller.allocateCredit(
                          userId: userId!,
                          orderCreditId: credit.id,
                          amount: amount,
                          description: descriptionController.text.isEmpty
                              ? 'bayar'
                              : descriptionController.text,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4DD0E1),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey,
              ),
              child: controller.isSubmitting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Alokasi'),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog untuk bayar penuh
  void _showBayarPenuhDialog(CreditModel credit) {
    if (userId == null) {
      Get.snackbar(
        'Error',
        'User ID tidak ditemukan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final descriptionController = TextEditingController(text: 'bayar penuh');

    // Hitung sisa yang harus dibayar
    final remaining = double.tryParse(credit.remainingAmount) ?? 0;
    final availableBalance =
        double.tryParse(
          controller.userBalance.value?.availableBalance ?? '0',
        ) ??
        0;

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Konfirmasi Pembayaran Penuh',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor Pesanan: ${credit.order?.orderNumber ?? "-"}',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Total Kredit', credit.formattedTotalAmount),
                  const Divider(),
                  _buildInfoRow('Teralokasi', credit.formattedAllocatedAmount),
                  const Divider(),
                  _buildInfoRow(
                    'Sisa yang Harus Dibayar',
                    credit.formattedRemainingAmount,
                    valueColor: Colors.red,
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: availableBalance >= remaining
                    ? Colors.green[50]
                    : Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Saldo Tersedia:', style: TextStyle(fontSize: 13)),
                  Obx(
                    () => Text(
                      controller.userBalance.value?.formattedAvailableBalance ??
                          'Rp 0',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: availableBalance >= remaining
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Keterangan
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Keterangan',
                border: OutlineInputBorder(),
                hintText: 'Contoh: bayar penuh',
              ),
            ),
            const SizedBox(height: 16),

            // Warning jika saldo tidak cukup
            if (availableBalance < remaining)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red[700], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Saldo tidak mencukupi untuk membayar penuh',
                        style: TextStyle(fontSize: 12, color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[700],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Saldo mencukupi untuk pembayaran penuh',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          Obx(
            () => ElevatedButton(
              onPressed:
                  (controller.isSubmitting.value ||
                      availableBalance < remaining)
                  ? null
                  : () {
                      // PERBAIKAN: Gunakan allocateCredit dengan amount = remaining
                      controller.allocateCredit(
                        userId: userId!,
                        orderCreditId: credit.id,
                        amount:
                            remaining, // Kirim amount = sisa yang harus dibayar
                        description: descriptionController.text.isEmpty
                            ? 'bayar penuh'
                            : descriptionController.text,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff55BC10),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey,
              ),
              child: controller.isSubmitting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Bayar Penuh'),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk info row
  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
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
  final CreditModel credit;
  final bool isLunas; // 🔥 Tambahkan parameter
  final VoidCallback onAlokasi;
  final VoidCallback onBayarPenuh;

  const _KreditPesananCard({
    required this.credit,
    required this.isLunas, // 🔥 Required
    required this.onAlokasi,
    required this.onBayarPenuh,
  });

  @override
  Widget build(BuildContext context) {
    final order = credit.order;

    // Format tanggal
    String formattedDate = '';
    try {
      final date = DateTime.parse(credit.createdAt);
      formattedDate =
          '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      formattedDate = '';
    }

    // Determine sisa color
    Color sisaColor = Colors.blue;
    final remaining = double.tryParse(credit.remainingAmount) ?? 0;
    final total = double.tryParse(credit.totalAmount) ?? 1;
    final percentage = total > 0 ? (remaining / total) * 100 : 0;

    if (percentage > 50) {
      sisaColor = Colors.red;
    } else if (percentage > 20) {
      sisaColor = Colors.orange;
    } else {
      sisaColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // 🔥 Tambah border jika sudah lunas
        border: isLunas
            ? Border.all(color: Colors.green[300]!, width: 2)
            : null,
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
          // 🔥 Badge "LUNAS" jika sudah lunas
          if (isLunas)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'LUNAS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Nomor pesanan", order?.orderNumber ?? "-"),
                    if (formattedDate.isNotEmpty) const SizedBox(height: 8),
                    if (formattedDate.isNotEmpty)
                      _buildInfoRow("Tanggal", formattedDate),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      "Total Kredit",
                      credit.formattedTotalAmount,
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
                    _buildInfoRow(
                      "Teralokasi",
                      credit.formattedAllocatedAmount,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      "Sisa",
                      credit.formattedRemainingAmount,
                      valueColor: isLunas ? Colors.green : sisaColor,
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
                        color: credit.statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        credit.statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          color: credit.statusColor,
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
                    onPressed: isLunas
                        ? null
                        : onAlokasi, // 🔥 Disable jika lunas
                    icon: const Icon(Icons.add, size: 14),
                    label: const Text(
                      "Alokasi",
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4DD0E1),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      minimumSize: const Size(0, 20),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton.icon(
                    onPressed: isLunas
                        ? null
                        : onBayarPenuh, // 🔥 Disable jika lunas
                    icon: const Icon(Icons.check_circle, size: 14),
                    label: const Text(
                      "Bayar Penuh",
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff55BC10),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      minimumSize: const Size(0, 20),
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
