import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Tambahalamat extends StatelessWidget {
  const Tambahalamat({super.key});

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
      body: SingleChildScrollView(
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
                  const Text(
                    "Tambah",
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
                    "Alamat",
                    style: const TextStyle(
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
              _buildMaterialTextField(hint: "Masukkan nama penerima"),

              const SizedBox(height: 16),

              // === SWITCH AKTIF ===
              Row(
                children: [
                  Switch(
                    value: true,
                    onChanged: (_) {},
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
                  Text("Alamat Pertama"),
                  Text(
                    "*wajib diisi",
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _buildMaterialTextField(hint: "Masukkan alamat pertama"),

              const SizedBox(height: 16),

              // === ALAMAT KEDUA ===
              const Text("Alamat Kedua (opsional)"),
              const SizedBox(height: 6),
              _buildMaterialTextField(hint: "Masukkan alamat kedua"),

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
                        _buildMaterialDropdown(hint: "Pilih Kota/Kab"),
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
                        _buildMaterialDropdown(hint: "Pilih Kec"),
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
              _buildMaterialTextField(hint: "Masukkan kode pos"),

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
              _buildMaterialTextField(hint: "Masukkan nomor telepon"),

              const SizedBox(height: 30),

              // === TOMBOL ===
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                      onPressed: () {},
                      child: const Text(
                        "Buat",
                        style: TextStyle(color: Colors.white, fontSize: 13),
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
                      onPressed: () {},
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
    );
  }

  // ====== WIDGET BANTUAN ======

  static Widget _buildMaterialTextField({required String hint}) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(8),
      child: TextField(
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

  static Widget _buildMaterialDropdown({required String hint}) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(8),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
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
        items: const [],
        onChanged: (_) {},
      ),
    );
  }
}
