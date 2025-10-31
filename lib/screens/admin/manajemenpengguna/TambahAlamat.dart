import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:get/get.dart';
import 'package:my_app/controller/users_controller.dart';
import 'package:my_app/screens/admin/manajemenpengguna/DetailPengguna.dart';

class Tambahalamat extends StatefulWidget {
  final Map<String, dynamic>? address;

  const Tambahalamat({super.key, this.address});

  @override
  State<Tambahalamat> createState() => _TambahalamatState();
}

class _TambahalamatState extends State<Tambahalamat> {
  bool isActive = true;
  int? selectedCityId;
  int? selectedDistrictId;

  final nameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final postalController = TextEditingController();
  final phoneController = TextEditingController();

  late int userId;
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    userId = args['userId'];
    userController.fetchCities();

    if (widget.address != null) {
      // Isi data jika edit
      nameController.text = widget.address!['shipping_name'] ?? '';
      address1Controller.text = widget.address!['address_line1'] ?? '';
      address2Controller.text = widget.address!['address_line2'] ?? '';
      postalController.text = widget.address!['postal_code'] ?? '';
      phoneController.text = widget.address!['phone'] ?? '';
      isActive = widget.address!['is_default'] ?? false;

      // Set city and district
      if (widget.address!['city_id'] != null) {
        selectedCityId = int.tryParse(widget.address!['city_id'].toString());
      }
      if (widget.address!['district_id'] != null) {
        selectedDistrictId = int.tryParse(
          widget.address!['district_id'].toString(),
        );
      }

      if (selectedCityId != null) {
        userController.fetchDistricts(selectedCityId!);
      }
    }
  }

  Future<void> saveAddress() async {
    final body = {
      "shipping_name": nameController.text,
      "address_line1": address1Controller.text,
      "address_line2": address2Controller.text,
      "district_id": selectedDistrictId
          ?.toString(), // Convert to string as API expects
      "city_id": selectedCityId?.toString(), // Convert to string as API expects
      "postal_code": postalController.text,
      "phone": phoneController.text,
      "is_default": isActive,
    };

    try {
      if (widget.address != null) {
        // update existing address
        await userController.updateAddress(
          userId: userId,
          addressId: widget.address!['id'],
          data: body,
        );
      } else {
        // Create new address
        await userController.createAddress(userId: userId, data: body);
      }

      Get.off(() => Detailpengguna(userId: userId));
    } catch (e) {
      Get.snackbar(
        "Error",
        widget.address != null
            ? "Gagal memperbarui alamat"
            : "Gagal menambah alamat",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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

      // === ISI BODY ===
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.address != null ? "Edit" : "Tambah",
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
                      "Alamat",
                      style: TextStyle(
                        fontFamily: "Primary",
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // === NAMA PENERIMA ===
                const Text("Nama Penerima"),
                const SizedBox(height: 6),
                _buildMaterialTextField(
                  controller: nameController,
                  hint: "Masukkan nama penerima",
                ),

                const SizedBox(height: 16),

                // === SWITCH AKTIF ===
                Row(
                  children: [
                    Switch(
                      value: isActive,
                      onChanged: (v) {
                        setState(() => isActive = v);
                      },
                      activeColor: const Color(0xffF26D2B),
                    ),
                    const Text(
                      "Aktif",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const Text(
                  "Jadikan Alamat Utama",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),

                const SizedBox(height: 16),

                // === ALAMAT PERTAMA ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Alamat Lengkap"),
                    Text(
                      "*wajib diisi",
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildMaterialTextField(
                  controller: address1Controller,
                  hint: "Masukkan alamat pertama",
                ),

                const SizedBox(height: 16),

                // === ALAMAT KEDUA ===
                const Text("Alamat Kedua (opsional)"),
                const SizedBox(height: 6),
                _buildMaterialTextField(
                  controller: address2Controller,
                  hint: "Masukkan alamat kedua",
                ),

                const SizedBox(height: 16),

                // === KOTA & KECAMATAN ===
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Kota/Kabupaten"),
                          const SizedBox(height: 6),
                          _buildMaterialDropdown(
                            hint: "Pilih Kota/Kab",
                            items: userController.cities,
                            value: selectedCityId,
                            onTap: () async {
                              if (userController.cities.isEmpty) {
                                await userController.fetchCities();
                              }
                            },
                            onChanged: (val) async {
                              setState(() {
                                selectedCityId = val;
                                selectedDistrictId = null;
                              });
                              if (val != null) {
                                await userController.fetchDistricts(val);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Kecamatan"),
                          const SizedBox(height: 6),
                          _buildMaterialDropdown(
                            hint: "Pilih Kec",
                            items: userController.districts,
                            value: selectedDistrictId,
                            onTap: () async {
                              if (selectedCityId != null) {
                                await userController.fetchDistricts(
                                  selectedCityId!,
                                );
                              }
                            },
                            onChanged: (val) {
                              setState(() => selectedDistrictId = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // === KODE POS ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Kode Pos"),
                    Text(
                      "*wajib diisi",
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildMaterialTextField(
                  controller: postalController,
                  hint: "Masukkan kode pos",
                ),

                const SizedBox(height: 16),

                // === NOMOR TELEPON ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Nomor Telepon"),
                    Text(
                      "*wajib diisi",
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildMaterialTextField(
                  controller: phoneController,
                  hint: "Masukkan nomor telepon",
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF26D2B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: saveAddress,
                        child: Text(
                          widget.address != null ? "Simpan" : "Buat",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      height: 35,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () => Get.back(),
                        child: const Text(
                          "Batal",
                          style: TextStyle(fontSize: 13),
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
    );
  }

  // ====== REUSABLE ======

  static Widget _buildMaterialTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  static Widget _buildMaterialDropdown({
    required String hint,
    required List items,
    required int? value,
    required Function(int?) onChanged,
    Function()? onTap,
  }) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(8),
      child: DropdownButtonFormField<int>(
        isExpanded: true,
        value: value,
        onTap: onTap,
        style: const TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        items: items
            .map(
              (e) =>
                  DropdownMenuItem<int>(value: e['id'], child: Text(e['name'])),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
