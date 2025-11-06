import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/order_controller.dart';
import 'package:my_app/controller/product_controller.dart';
import 'package:my_app/controller/users_controller.dart';
import 'package:my_app/data/models/product_model.dart';
import 'package:my_app/helper/utils.dart';
import 'package:my_app/routes/app_routes.dart';

class Buatpesanan extends StatefulWidget {
  const Buatpesanan({super.key});

  @override
  State<Buatpesanan> createState() => _BuatpesananState();
}

class _BuatpesananState extends State<Buatpesanan> {
  //pelanggan

  //kurir
  String? selectedKurir;

  //tanggal
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedDate.hour,
          selectedDate.minute,
        );
      });
    }
  }

  //produk
  List<ItemPesanan> items = [];
  final TextEditingController totalHargaController = TextEditingController(
    text: '0',
  );

  void _tambahItem() {
    setState(() {
      final item = ItemPesanan();

      // Set listener untuk hitung subtotal & total harga otomatis
      item.jumlahController.addListener(() {
        setState(() {
          item.hitungSubtotal();
          _hitungTotalHarga();
        });
      });
      item.hargaController.addListener(() {
        setState(() {
          item.hitungSubtotal();
          _hitungTotalHarga();
        });
      });

      items.add(item);
    });
  }

  void _hapusItem(int index) {
    setState(() {
      items[index].dispose();
      items.removeAt(index);
      _hitungTotalHarga();
    });
  }

  // Fungsi hitung total harga semua item
  // void _hitungTotalHarga() {
  //   int total = 0;
  //   for (var item in items) {
  //     total += int.tryParse(item.subtotalController.text) ?? 0;
  //   }
  //   totalHargaController.text = total.toString();
  // }

  void _hitungTotalHarga() {
    int total = 0;
    for (var item in items) {
      total += item.subtotal; // pakai int asli
    }
    totalHargaController.text = total.toString();
  }

  @override
  void dispose() {
    for (var item in items) {
      item.dispose();
    }
    totalHargaController.dispose();
    super.dispose();
  }

  //variabel user controller
  final userController = Get.put(UserController());
  String? selectedPelanggan;
  String? selectedPelangganId;
  String? selectedKurirName;
  String? selectedAlamat; // akan simpan nama / label
  int? selectedAlamatId;
  int? selectedKurirId;
  bool alamatUserPicked = false;

  //produk controller
  final productController = Get.find<ProductController>();

  //buatpesanan
  final orderController = Get.put(OrderController());

  bool isLoading = false;

  Future<void> submitPesanan() async {
    print("=== MULAI BUAT PESANAN ===");

    if (selectedPelangganId == null ||
        selectedAlamatId == null ||
        selectedKurirId == null ||
        items.isEmpty) {
      print("Data belum lengkap");
      Get.snackbar("Gagal", "Lengkapi semua data pesanan terlebih dahulu");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final orderItems = items.map((item) {
      final jumlah = int.tryParse(item.jumlahController.text) ?? 0;
      final harga =
          item.product?.price ??
          double.tryParse(item.hargaController.text) ??
          0;
      final subtotal = (jumlah * harga).toInt();

      return {
        "product_id": item.productId,
        "quantity": jumlah,
        "price": harga.toInt(),
        "subtotal": subtotal,
      };
    }).toList();

    final totalAmount = orderItems.fold<int>(
      0,
      (sum, i) => sum + (i["subtotal"] as int),
    );
    final deposit = 0;
    final orderDate = DateTime.now().toIso8601String();

    print("User ID: $selectedPelangganId");
    print("Address ID: $selectedAlamatId");
    print("Courier ID: $selectedKurirId");
    print("Order Date: $orderDate");
    print("Total: $totalAmount");
    print("Items: $orderItems");

    try {
      await orderController.createOrder(
        userId: int.parse(selectedPelangganId!),
        userAddressId: selectedAlamatId!,
        courierId: selectedKurirId!,
        orderDate: orderDate,
        totalAmount: totalAmount,
        deposit: deposit,
        orderItems: orderItems,
      );

      print("PESANAN BERHASIL DIKIRIM");

      setState(() {
        items.clear();
        totalHargaController.text = '0';
        selectedAlamat = null;
        selectedKurir = null;
        selectedPelanggan = null;
      });

      Get.snackbar(
        "Sukses",
        "Pesanan berhasil dibuat!",
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Gagal kirim pesanan: $e");
      Get.snackbar(
        "Error",
        "Gagal membuat pesanan",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await userController.getUsers();

      while (userController.currentPage.value < userController.lastPage.value) {
        print(
          'Memuat halaman ${userController.currentPage.value + 1} dari ${userController.lastPage.value}',
        );
        await userController.loadMoreUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/image.png"),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 80),
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
                    "Buat",
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

            // pelanggan
            const Padding(
              padding: EdgeInsets.only(top: 30, left: 28, right: 28),
              child: Text(
                "Pelanggan",
                style: TextStyle(
                  fontFamily: "Primary",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            //dropdown pelanggan
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Obx(() {
                // Ambil hanya pelanggan dari list reactive
                final pelangganList = userController.users
                    .where((u) => u.role == 'customer')
                    .map((u) => u.name ?? '-')
                    .toList();

                return Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  child: DropdownSearch<String>(
                    items: pelangganList,
                    selectedItem: selectedPelanggan,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Pilih Pelanggan",
                        prefixIcon: const Icon(Icons.person_outline),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                      ),
                    ),
                    popupProps: PopupProps.menu(
                      showSearchBox: false,
                      fit: FlexFit.loose,
                      menuProps: MenuProps(
                        backgroundColor: Colors.white,
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xffF26D2B)
                                  : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                    onChanged: (value) async {
                      if (value == null) return;

                      setState(() {
                        selectedPelanggan = value;
                        selectedAlamat = null;
                        selectedAlamatId = null;
                        alamatUserPicked = false;
                      });

                      final picked = userController.users.firstWhere(
                        (u) => u.name == value,
                      );

                      selectedPelangganId = picked.id.toString();

                      await userController.getUserDetail(picked.id);
                    },
                  ),
                );
              }),
            ),

            //alamat pengiriman
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Text(
                "Alamat Pengiriman",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Primary",
                  color: Colors.black,
                ),
              ),
            ),
            // Dropdown biasa
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Obx(() {
                final user = userController.userDetail.value;

                if (user == null || user.addresses.isEmpty) {
                  return Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8),
                    shadowColor: Colors.transparent,
                    surfaceTintColor:
                        Colors.transparent, // hilangkan border hitam
                    child: DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width - 56,
                      leadingIcon: const Icon(Icons.location_on_outlined),
                      hintText: "Belum ada alamat",
                      dropdownMenuEntries: const [],
                    ),
                  );
                }

                final defaultAddress = user.addresses.firstWhere(
                  (a) => a.isDefault == true,
                  orElse: () => user.addresses.first,
                );

                Future.microtask(() {
                  if (!alamatUserPicked &&
                      (selectedAlamatId != defaultAddress.id)) {
                    setState(() {
                      selectedAlamat = defaultAddress.addressLine1;
                      selectedAlamatId = defaultAddress.id;
                    });
                  }
                });

                return Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8),
                  child: DropdownMenu<String>(
                    width: MediaQuery.of(context).size.width - 56,
                    initialSelection: selectedAlamat,
                    leadingIcon: const Icon(Icons.location_on_outlined),
                    hintText: "Pilih Alamat Pengiriman",
                    onSelected: (value) {
                      if (value == null) return;

                      final picked = user.addresses.firstWhere(
                        (a) => a.addressLine1 == value,
                      );

                      setState(() {
                        selectedAlamat = picked.addressLine1;
                        selectedAlamatId = picked.id;

                        // tandai bahwa user sudah memilih alamat sendiri
                        alamatUserPicked = true;
                      });
                    },
                    dropdownMenuEntries: user.addresses.map((alamat) {
                      return DropdownMenuEntry(
                        value: alamat.addressLine1,
                        label: alamat.addressLine1,
                      );
                    }).toList(),
                  ),
                );
              }),
            ),

            //kurir dan tanggal
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Row(
                children: [
                  // Dropdown Kurir
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kurir",
                          style: TextStyle(
                            fontFamily: "Primary",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(() {
                          final kurirList = userController.users
                              .where((u) => u.role == 'courier')
                              .toList();

                          return Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(8),
                            child: DropdownMenu<String>(
                              width: double.infinity,
                              initialSelection: selectedKurir,
                              leadingIcon: const Icon(
                                Icons.local_shipping_outlined,
                              ),
                              inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              hintText: 'Pilih Kurir',
                              onSelected: (value) {
                                if (value == null) return;

                                final picked = kurirList.firstWhere(
                                  (u) => u.name == value,
                                );

                                setState(() {
                                  selectedKurir = picked.name;
                                  selectedKurirId = picked.id; // ID tersimpan
                                });

                                print(
                                  "Dipilih kurir -> name=${picked.name}, id=${picked.id}",
                                );
                              },
                              dropdownMenuEntries: kurirList.map((kurir) {
                                return DropdownMenuEntry(
                                  value: kurir.name ?? '-',
                                  label: kurir.name ?? '-',
                                );
                              }).toList(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Tanggal Pesanan
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tanggal Pesanan",
                          style: TextStyle(
                            fontFamily: "Primary",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(8),
                          child: TextField(
                            readOnly: true,
                            onTap: _selectDate,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                              ),
                              hintText:
                                  "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year} ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}",
                              hintStyle: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //item pesanan
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header + Tombol Tambah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Item Pesanan",
                        style: TextStyle(
                          fontFamily: "Primary",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF26D2B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        onPressed: _tambahItem,
                        child: const Text(
                          "Tambah Item",
                          style: TextStyle(
                            fontFamily: "Primary",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),

                  ...items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // Baris Produk + Jumlah + Tombol Hapus
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Produk",
                                    style: TextStyle(
                                      fontFamily: "Primary",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Obx(() {
                                      final listProduk =
                                          productController.products;
                                      print(
                                        'Jumlah produk: ${listProduk.length}',
                                      );

                                      return DropdownMenu<String>(
                                        width: double.infinity,
                                        initialSelection: item.selectedProduk,
                                        hintText: 'Pilih Produk',
                                        onSelected: (value) {
                                          if (value == null) return;
                                          print('Produk dipilih: $value');

                                          setState(() {
                                            item.selectedProduk = value;

                                            final picked = listProduk
                                                .firstWhere(
                                                  (p) => p.name == value,
                                                );

                                            item.productId = picked.id;

                                            item.hargaController.text = picked
                                                .price
                                                .toString();

                                            item.hitungSubtotal();
                                            _hitungTotalHarga();
                                          });
                                        },
                                        dropdownMenuEntries: listProduk
                                            .map(
                                              (produk) => DropdownMenuEntry(
                                                value: produk.name,
                                                label: produk.name,
                                              ),
                                            )
                                            .toList(),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Jumlah",
                                    style: TextStyle(
                                      fontFamily: "Primary",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(8),
                                    child: TextField(
                                      controller: item.jumlahController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) =>
                                          setState(item.hitungSubtotal),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: '0',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _hapusItem(index),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        // Baris Harga Satuan + Subtotal
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Harga Satuan",
                                    style: TextStyle(
                                      fontFamily: "Primary",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(8),
                                    child: TextField(
                                      controller: item.hargaController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        // Hapus semua selain angka
                                        String cleaned = value.replaceAll(
                                          RegExp(r'[^0-9]'),
                                          '',
                                        );

                                        int intValue =
                                            int.tryParse(cleaned) ?? 0;

                                        String formatted = formatRupiah(
                                          intValue,
                                        );

                                        setState(() {
                                          item
                                              .hargaController
                                              .value = TextEditingValue(
                                            text: formatted,
                                            selection: TextSelection.collapsed(
                                              offset: formatted.length,
                                            ),
                                          );

                                          item.hitungSubtotal();
                                        });
                                      },

                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        // prefixText: 'Rp. ',
                                        hintText: 'Rp 0',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Subtotal",
                                    style: TextStyle(
                                      fontFamily: "Primary",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(8),
                                    child: TextField(
                                      controller: item.subtotalController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        // prefixText: 'Rp. ',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: '0',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                      ],
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Harga",
                    style: TextStyle(
                      fontFamily: "Primary",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8),
                    child: TextField(
                      controller: totalHargaController,
                      readOnly: true,
                      decoration: InputDecoration(
                        // prefixText: 'Rp. ',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '0',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tombol Buat Pesanan & Batal
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffF26D2B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: isLoading ? null : submitPesanan,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Buat Pesanan",
                                  style: TextStyle(
                                    fontFamily: "Primary",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            // Aksi batal
                            setState(() {
                              items.clear();
                              totalHargaController.text = '0';
                            });
                          },
                          child: const Text(
                            "Batal",
                            style: TextStyle(
                              fontFamily: "Primary",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
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

class ItemPesanan {
  ProductModel? product;
  String? selectedProduk;
  int? productId;

  TextEditingController jumlahController = TextEditingController(text: "0");
  TextEditingController hargaController = TextEditingController(text: "0");
  TextEditingController subtotalController = TextEditingController(text: "0");

  int subtotal = 0;

  ItemPesanan({this.product}) {
    if (product != null) {
      productId = product!.id;
      selectedProduk = product!.name;

      hargaController.text = product!.price.toStringAsFixed(0);
    }
  }

  void setProduct(ProductModel model) {
    product = model;
    productId = model.id;
    selectedProduk = model.name;
    hargaController.text = model.price.toStringAsFixed(0);
    hitungSubtotal();
  }

  void hitungSubtotal() {
    final jumlah = int.tryParse(jumlahController.text) ?? 0;
    final harga = double.tryParse(hargaController.text) ?? 0;

    subtotal = (jumlah * harga).toInt(); // konversi ke int kalau perlu
    subtotalController.text = subtotal.toString();

    print('DEBUG jumlah: $jumlah, harga: $harga, subtotal: $subtotal');
  }

  void dispose() {
    jumlahController.dispose();
    hargaController.dispose();
    subtotalController.dispose();
  }
}
