import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/controller/category_controller.dart';
import 'package:my_app/data/api/category_api.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Tambahkategori extends StatefulWidget {
  const Tambahkategori({super.key});

  @override
  State<Tambahkategori> createState() => _TambahkategoriState();
}

class _TambahkategoriState extends State<Tambahkategori> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    var status = await Permission.photos.request(); // iOS & Android 13
    var storageStatus = await Permission.storage
        .request(); // Android 12 ke bawah

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

  void _submitForm() async {
    final nama = _namaController.text.trim();
    final deskripsi = _deskripsiController.text.trim();

    if (nama.isEmpty || deskripsi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan deskripsi wajib diisi")),
      );
      return;
    }

    print('🚀 Kirim kategori: $nama - $deskripsi');

    try {
      // Gunakan controller langsung
      final controller = Get.find<CategoryController>();
      await controller.addCategory(nama, deskripsi);

      _resetForm();
      Navigator.pop(context); // Balik ke halaman kategori
    } catch (e) {
      print('Error tambah kategori: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menambahkan kategori: $e")));
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
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Padding(
              padding: const EdgeInsets.only(top: 31, left: 28),
              child: Row(
                children: const [
                  Text(
                    "Kategori",
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

            // Gambar
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 28),
              child: Text(
                "Gambar",
                style: TextStyle(
                  fontFamily: "Primary",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   width: 183,
                  //   child: ElevatedButton(
                  //     onPressed: _pickImage,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xffEE6C22),
                  //       padding: const EdgeInsets.symmetric(vertical: 14),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(6),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       "Tambahkan gambar",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Preview
                  // if (_selectedImage != null) ...[
                  //   const SizedBox(height: 12),
                  //   Stack(
                  //     children: [
                  //       SizedBox(
                  //         width: 120,
                  //         height: 120,
                  //         child: ClipRRect(
                  //           borderRadius: BorderRadius.circular(8),
                  //           child: Image.file(
                  //             _selectedImage!,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //       Positioned(
                  //         top: 4,
                  //         right: 4,
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               _selectedImage = null;
                  //             });
                  //           },
                  //           child: Container(
                  //             decoration: const BoxDecoration(
                  //               color: Colors.black54,
                  //               shape: BoxShape.circle,
                  //             ),
                  //             padding: const EdgeInsets.all(4),
                  //             child: const Icon(
                  //               Icons.close,
                  //               color: Colors.white,
                  //               size: 18,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ],

                  // Tombol Buat & Batal
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 41),
                        child: SizedBox(
                          width: 79,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffEE9400),
                              ),
                              shape:
                                  MaterialStateProperty.all<
                                    RoundedRectangleBorder
                                  >(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                            ),
                            onPressed: _submitForm,
                            child: const Text(
                              "Buat",
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
                                  MaterialStateProperty.all<
                                    RoundedRectangleBorder
                                  >(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
