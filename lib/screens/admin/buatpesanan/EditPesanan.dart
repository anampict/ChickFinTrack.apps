import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controller/order_controller.dart';
import 'package:my_app/controller/product_controller.dart';
import 'package:my_app/controller/users_controller.dart';
import 'package:my_app/data/models/order_model.dart';
import 'package:my_app/data/models/users_model.dart';
import 'package:my_app/data/models/users_model.dart' as user_data;
import 'package:my_app/screens/admin/buatpesanan/BuatPesanan.dart';

class EditPesanan extends StatefulWidget {
  final OrderModel order;

  const EditPesanan({super.key, required this.order});

  @override
  State<EditPesanan> createState() => _EditpesananState();
}

class _EditpesananState extends State<EditPesanan> {
  // Variabel controllers
  final userController = Get.find<UserController>();
  final productController = Get.find<ProductController>();
  final orderController = Get.find<OrderController>();

  // Form variables
  String? selectedPelanggan;
  String? selectedPelangganId;
  String? selectedKurirName;
  String? selectedAlamat;
  int? selectedAlamatId;
  int? selectedKurirId;
  bool alamatUserPicked = false;

  DateTime selectedDate = DateTime.now();
  List<ItemPesanan> items = [];
  final TextEditingController totalHargaController = TextEditingController(
    text: '0',
  );
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrderData();
  }

  // Load data dari order yang akan diedit
  Future<void> _loadOrderData() async {
    try {
      // Load user detail
      await userController.getUserDetail(widget.order.userId);

      setState(() {
        // Set pelanggan
        selectedPelanggan = widget.order.user?.name;
        selectedPelangganId = widget.order.userId.toString();

        // Set kurir
        selectedKurirName = widget.order.courier?.name;
        selectedKurirId = widget.order.courierId;

        // Set tanggal
        try {
          selectedDate = DateTime.parse(widget.order.orderDate);
          print('Selected date: $selectedDate');
        } catch (e) {
          print('Error parsing date: $e');
          selectedDate = DateTime.now();
        }

        // Set alamat
        final user = userController.userDetail.value;
        final alamat = _findAddress(user, widget.order.userAddressId);

        if (alamat != null) {
          selectedAlamat = alamat.addressLine1;
          selectedAlamatId = alamat.id;
          print('Address found: ${alamat.addressLine1}');
        }

        // Set items
        items =
            widget.order.orderItems?.map((orderItem) {
              print('\n--- Loading Order Item ---');
              print('Product: ${orderItem.product?.name}');
              print('Quantity: ${orderItem.quantity}');
              print('Price: ${orderItem.priceAtPurchase}');

              final item = ItemPesanan();
              item.productId = orderItem.productId;
              item.selectedProduk = orderItem.product?.name;
              item.product = orderItem.product;

              // Set jumlah
              item.jumlahController.text = orderItem.quantity.toString();

              // Set harga dengan format rupiah
              final hargaValue = orderItem.priceAtPurchase.toInt();
              item.hargaController.text = formatRupiah(hargaValue);

              print('After set:');
              print('- jumlahController: ${item.jumlahController.text}');
              print('- hargaController: ${item.hargaController.text}');

              // Hitung subtotal
              item.hitungSubtotal();

              print('After hitungSubtotal:');
              print('- subtotal: ${item.subtotal}');
              print('- subtotalController: ${item.subtotalController.text}');

              // Add listeners
              item.jumlahController.addListener(() {
                if (mounted) {
                  setState(() {
                    item.hitungSubtotal();
                    _hitungTotalHarga();
                  });
                }
              });

              item.hargaController.addListener(() {
                if (mounted) {
                  setState(() {
                    item.hitungSubtotal();
                    _hitungTotalHarga();
                  });
                }
              });

              return item;
            }).toList() ??
            [];

        print('\n=== ITEMS LOADED ===');
        print('Total items: ${items.length}');

        // Hitung total harga
        _hitungTotalHarga();

        print('Total harga: ${totalHargaController.text}');
      });

      print('=== LOAD ORDER DATA SELESAI ===\n');
    } catch (e, stackTrace) {
      print('=== ERROR LOADING ORDER DATA ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        Get.snackbar(
          'Error',
          'Gagal memuat data pesanan: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    }
  }

  AddressModel? _findAddress(user_data.UserModel? user, String userAddressId) {
    if (user == null || user.addresses.isEmpty) return null;

    try {
      return user.addresses.firstWhere(
        (a) => a.id.toString() == userAddressId.toString(),
      );
    } catch (e) {
      return user.addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => user.addresses.first,
      );
    }
  }

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

  void _tambahItem() {
    setState(() {
      final item = ItemPesanan();

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

  void _hitungTotalHarga() {
    int total = 0;
    for (var item in items) {
      total += item.subtotal;
    }
    totalHargaController.text = total.toString();
  }

  Future<void> submitUpdate() async {
    print("=== MULAI UPDATE PESANAN ===");

    if (selectedPelangganId == null ||
        selectedAlamatId == null ||
        selectedKurirId == null ||
        items.isEmpty) {
      Get.snackbar("Gagal", "Lengkapi semua data pesanan terlebih dahulu");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final orderItems = items.map((item) {
      final jumlah = int.tryParse(item.jumlahController.text) ?? 0;

      // Hapus format rupiah dari harga
      final hargaText = item.hargaController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      final harga = double.tryParse(hargaText) ?? 0;
      final subtotal = (jumlah * harga).toInt();

      return {
        "product_id": item.productId,
        "quantity": jumlah,
        "price_at_purchase": harga.toInt(), // Sesuaikan dengan backend
      };
    }).toList();

    final totalAmount = orderItems.fold<int>(
      0,
      (sum, i) =>
          sum + ((i["quantity"] as int) * (i["price_at_purchase"] as int)),
    );
    final deposit = 0;

    // Format tanggal ke ISO8601 String
    final orderDate = selectedDate.toIso8601String();

    print("Order ID: ${widget.order.id}");
    print("User ID: $selectedPelangganId");
    print("Address ID: $selectedAlamatId");
    print("Courier ID: $selectedKurirId");
    print("Order Date: $orderDate");
    print("Total: $totalAmount");
    print("Items: $orderItems");

    try {
      await orderController.updateOrder(
        orderId: widget.order.id,
        userId: int.parse(selectedPelangganId!),
        userAddressId: selectedAlamatId!,
        courierId: selectedKurirId!,
        orderDate: orderDate,
        totalAmount: totalAmount,
        deposit: deposit,
        orderItems: orderItems,
      );

      print("PESANAN BERHASIL DIUPDATE");

      // Kembali ke halaman sebelumnya
      Get.back();

      // Tampilkan snackbar sukses
      Get.snackbar(
        "Sukses",
        "Pesanan berhasil diupdate!",
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Gagal update pesanan: $e");
      Get.snackbar(
        "Error",
        "Gagal update pesanan: $e",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    for (var item in items) {
      item.dispose();
    }
    totalHargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
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
                    "Edit",
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

            // Order Number Info
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 28, right: 28),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xffF26D2B)),
                    const SizedBox(width: 8),
                    Text(
                      "Edit Pesanan: ${widget.order.orderNumber}",
                      style: const TextStyle(
                        fontFamily: "Primary",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffF26D2B),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pelanggan
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 28, right: 28),
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

            // Dropdown pelanggan
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Obx(() {
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

            // Alamat pengiriman
            const Padding(
              padding: EdgeInsets.only(top: 9, left: 28, right: 28),
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

            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Obx(() {
                final user = userController.userDetail.value;

                if (user == null || user.addresses.isEmpty) {
                  return Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8),
                    child: DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width - 56,
                      leadingIcon: const Icon(Icons.location_on_outlined),
                      hintText: "Belum ada alamat",
                      dropdownMenuEntries: const [],
                    ),
                  );
                }

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

            // Kurir dan Tanggal
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
                              initialSelection: selectedKurirName,
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
                              ),
                              hintText: 'Pilih Kurir',
                              onSelected: (value) {
                                if (value == null) return;

                                final picked = kurirList.firstWhere(
                                  (u) => u.name == value,
                                );

                                setState(() {
                                  selectedKurirName = picked.name;
                                  selectedKurirId = picked.id;
                                });
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

            // Item Pesanan
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                                      return DropdownMenu<String>(
                                        width: double.infinity,
                                        initialSelection: item.selectedProduk,
                                        hintText: 'Pilih Produk',
                                        onSelected: (value) {
                                          if (value == null) return;

                                          setState(() {
                                            item.selectedProduk = value;

                                            final picked = listProduk
                                                .firstWhere(
                                                  (p) => p.name == value,
                                                );

                                            item.productId = picked.id;
                                            item.hargaController.text =
                                                formatRupiah(
                                                  picked.price.toInt(),
                                                );
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
                                        hintText: 'Rp 0',
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

            // Total Harga
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

                  // Tombol Update & Batal
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
                          onPressed: isLoading ? null : submitUpdate,
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
                                  "Update Pesanan",
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
                            Get.back();
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

// Helper function untuk format rupiah
String formatRupiah(int amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(amount);
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

    // Hapus semua karakter non-digit (Rp, titik, spasi, dll)
    final hargaText = hargaController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final harga =
        int.tryParse(hargaText) ??
        0; // UBAH INI dari double.tryParse ke int.tryParse

    subtotal = jumlah * harga;
    subtotalController.text = subtotal.toString();
  }

  void dispose() {
    jumlahController.dispose();
    hargaController.dispose();
    subtotalController.dispose();
  }
}
