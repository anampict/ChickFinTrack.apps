import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:my_app/controller/category_controller.dart';
import 'package:my_app/controller/product_controller.dart';
import 'package:my_app/data/api/api_config.dart';
import 'package:my_app/data/models/category_model.dart';
import 'package:my_app/data/models/product_model.dart';
import 'package:permission_handler/permission_handler.dart';

class TambahProduk extends StatefulWidget {
  final ProductModel? product; // null = tambah, ada = edit

  const TambahProduk({super.key, this.product});

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _skuController = TextEditingController();
  final _weightController = TextEditingController();

  bool isActive = false;
  File? _selectedImage;
  String? _imageUrl;
  CategoryModel? selectedCategory;

  final categoryController = Get.find<CategoryController>();
  final productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    categoryController.fetchCategories();

    // Jika edit, isi field dengan data produk
    if (widget.product != null) {
      final p = widget.product!;
      _nameController.text = p.name ?? '';
      _descController.text = p.description ?? '';
      _priceController.text = p.price?.toString() ?? '';
      _stockController.text = p.stock?.toString() ?? '';
      _skuController.text = p.sku ?? '';
      _weightController.text = p.weight?.toString() ?? '';
      isActive = p.isActive ?? false;
      _imageUrl = p.imageUrl;
      // Tunggu kategori terload, lalu set selectedCategory
      Future<void> _setSelectedCategory() async {
        await Future.delayed(Duration(milliseconds: 100)); // beri waktu fetch
        final p = widget.product!;
        final cat = categoryController.categories.firstWhereOrNull(
          (c) => c.id == p.categoryId,
        );
        if (cat != null) {
          setState(() {
            selectedCategory = cat;
          });
        }
      }
    }
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
          _imageUrl = null; // reset jika ganti gambar
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

  Future<String?> _uploadImage(File file) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://chickfintrack.id/api/upload/image'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', file.path));
      request.headers.addAll(ApiConfig.headers);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(respStr);
        final imagePath = json['data'];
        final fullUrl = 'https://chickfintrack.id/storage/$imagePath';
        return fullUrl;
      } else {
        Get.snackbar(
          'Error',
          'Gagal upload gambar (${response.statusCode})',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat upload gambar',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return null;
    }
  }

  Future<void> _submitProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _skuController.text.isEmpty ||
        selectedCategory == null) {
      Get.snackbar(
        'Peringatan',
        'Harap isi semua field wajib',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      return;
    }

    String? imageUrl = _imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
      if (imageUrl == null) return;
    }

    final body = {
      "name": _nameController.text.trim(),
      "description": _descController.text.trim(),
      "price": _priceController.text.trim(),
      "stock": _stockController.text.trim(),
      "sku": _skuController.text.trim(),
      "category_id": selectedCategory!.id,
      "image_url": imageUrl,
      "weight": _weightController.text.trim().isEmpty
          ? null
          : _weightController.text.trim(),
      "dimensions": null,
      "is_active": isActive,
    };

    try {
      if (widget.product == null) {
        // TAMBAH
        await productController.addProduct(body);
        Get.snackbar(
          'Sukses',
          'Produk berhasil ditambahkan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
        );
      } else {
        // EDIT
        await productController.editProduct(widget.product!.id!, body);
        Get.snackbar(
          'Sukses',
          'Produk berhasil diupdate',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
        );
      }
      Navigator.pop(context);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal tambah/edit produk: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    }
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================== FIELD NAMA ==================
            const Padding(
              padding: EdgeInsets.only(left: 28, top: 31),
              child: Text(
                "Nama Produk",
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
                  controller: _nameController,
                  decoration: _inputDecoration("Masukkan nama produk"),
                ),
              ),
            ),

            // ================== DESKRIPSI ==================
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
                    controller: _descController,
                    maxLines: null,
                    decoration: _inputDecoration("Masukkan deskripsi produk"),
                  ),
                ),
              ),
            ),

            // ================== HARGA & STOK ==================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _numberField(
                      "Harga",
                      _priceController,
                      prefix: 'Rp.',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _numberField("Stok", _stockController)),
                ],
              ),
            ),

            // ================== SKU & KATEGORI ==================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Row(
                children: [
                  Expanded(child: _textField("SKU", _skuController)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(() {
                      if (categoryController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DropdownButtonFormField<CategoryModel>(
                        value: selectedCategory,
                        isExpanded: true,
                        decoration: _inputDecoration("Pilih kategori"),
                        items: categoryController.categories
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(
                                  cat.name ?? 'Tanpa Nama',
                                  style: TextStyle(
                                    fontFamily: "Primary",
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),

            // ================== BERAT & STATUS ==================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: _numberField(
                      "Berat (gram)",
                      _weightController,
                      suffix: 'gr',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: isActive,
                              onChanged: (v) => setState(() => isActive = v),
                              activeColor: const Color(0xffF26D2B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Aktif',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "Primary",
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Produk Akan Ditampilkan\nDihalaman Utama",
                        style: TextStyle(fontFamily: "Primary", fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================== IMAGE PICKER ==================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 183,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffEE6C22),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "Tambahkan gambar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  if (_selectedImage != null) ...[
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedImage = null),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (_imageUrl != null) ...[
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(_imageUrl!, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => setState(() => _imageUrl = null),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // ================== BUTTON BUAT/UPDATE & BATAL ==================
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 41),
              child: Row(
                children: [
                  SizedBox(
                    width: 79,
                    child: ElevatedButton(
                      onPressed: _submitProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffEE9400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        widget.product == null ? "Buat" : "Update",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Primary",
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: "Primary",
          ),
        ),
        const SizedBox(height: 6),
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(5),
          child: TextField(
            controller: controller,
            decoration: _inputDecoration("Masukkan $label"),
          ),
        ),
      ],
    );
  }

  Widget _numberField(
    String label,
    TextEditingController controller, {
    String? prefix,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: "Primary",
          ),
        ),
        const SizedBox(height: 6),
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(5),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDecoration('0').copyWith(
              prefixIcon: prefix != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 4,
                        top: 14,
                        bottom: 14,
                      ),
                      child: Text(
                        prefix,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: suffix != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                        top: 14,
                        bottom: 14,
                      ),
                      child: Text(
                        suffix,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
