import 'package:flutter/material.dart';

class Tambahkategori extends StatelessWidget {
  const Tambahkategori({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            // Foto Profil
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                "assets/images/image.png", // contoh foto online
              ),
            ),
            const SizedBox(width: 10),

            // Teks Salam + Nama
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
            padding: const EdgeInsets.only(right: 12), // kasih jarak ke kanan
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.mail, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Color(0xffF26D2B),
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 31, left: 28),
            child: Row(
              children: [
                Text(
                  "Kategori",
                  style: TextStyle(
                    fontFamily: "Primary",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,color: Colors.black
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
                    fontSize: 14,color: Colors.black
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28, top: 31),
            child: Text(
              "Nama Kategori",
              style: TextStyle(
                fontFamily: "Primary",
                fontWeight: FontWeight.w500,
                fontSize: 14,color: Colors.black
              ),
            ),
          ),
        ],
      ),
    );
  }
}
