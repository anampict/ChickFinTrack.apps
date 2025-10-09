import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/controller/category_controller.dart';
import 'package:my_app/data/api/category_api.dart';
import 'package:my_app/data/models/category_model.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Tambahkategori extends StatefulWidget {
  final CategoryModel? category; // null = tambah, ada = edit

  const Tambahkategori({Key? key, this.category}) : super(key: key);

  @override
  State<Tambahkategori> createState() => _TambahkategoriState();
}

class _TambahkategoriState extends State<Tambahkategori> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Kalau mode edit, isi field dengan data kategori
    if (widget.category != null) {
      _namaController.text = widget.category!.name;
      _deskripsiController.text = widget.category!.description ?? '';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    var status = await Permission.photos.request();
    var storageStatus = await Permission.storage.request();

    if (status.isGranted || storageStatus.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Izin galeri diperlukan untuk memilih gambar"),
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    final nama = _namaController.text.trim();
    final deskripsi = _deskripsiController.text.trim();

    if (nama.isEmpty || deskripsi.isEmpty) {
      Get.snackbar(
        "Validasi Gagal",
        "Nama dan deskripsi wajib diisi",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
      return;
    }

    final controller = Get.find<CategoryController>();

    try {
      if (widget.category == null) {
        // Tambah kategori
        await controller.addCategory(nama, deskripsi);
        Get.snackbar(
          "Sukses",
          "Kategori '$nama' berhasil ditambahkan",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
        );
      } else {
        // 🟡 Edit kategori
        await controller.updateCategory(widget.category!.id, nama, deskripsi);
        Get.snackbar(
          "Sukses",
          "Kategori '$nama' berhasil diperbarui",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
        );
      }

      _resetForm();
      Navigator.pop(context); // balik ke halaman kategori
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
    }
  }

  void _resetForm() {
    _namaController.clear();
    _deskripsiController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isEdit ? "Edit Kategori" : "Tambah Kategori",
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Primary",
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Padding(
              padding: const EdgeInsets.only(top: 31, left: 28),
              child: Row(
                children: [
                  const Text(
                    "Kategori",
                    style: TextStyle(
                      fontFamily: "Primary",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                  const SizedBox(width: 3),
                  Text(
                    isEdit ? "Edit" : "Buat",
                    style: const TextStyle(
                      fontFamily: "Primary",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Nama Kategori
            const Padding(
              padding: EdgeInsets.only(left: 28, top: 31),
              child: Text(
                "Nama Kategori",
                style: TextStyle(
                  fontFamily: "Primary",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(5),
                child: TextField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    hintText: "Masukkan nama kategori",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Deskripsi
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 28),
              child: Text(
                "Deskripsi",
                style: TextStyle(
                  fontFamily: "Primary",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  height: 114,
                  child: TextField(
                    controller: _deskripsiController,
                    decoration: InputDecoration(
                      hintText: "Masukkan deskripsi kategori",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: null,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Row(
                children: [
                  // Tombol Buat / Simpan
                  Padding(
                    padding: const EdgeInsets.only(top: 41),
                    child: SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffEE9400),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                        ),
                        onPressed: _submitForm,
                        child: Text(
                          isEdit ? "Simpan" : "Buat",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Primary",
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tombol Batal
                  Padding(
                    padding: const EdgeInsets.only(top: 41, left: 10),
                    child: SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffFFFFFF),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                        ),
                        onPressed: _resetForm,
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Primary",
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
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
    );
  }
}
