import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class DaftarPengguna extends StatelessWidget {
  const DaftarPengguna({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> users = [
      {
        "name": "Admin",
        "email": "admin@admin.com",
        "phone": "085732257048",
        "role": "Admin",
      },
      {
        "name": "Kurir",
        "email": "kurir@kurir.com",
        "phone": "085732257048",
        "role": "Kurir",
      },
      {
        "name": "Agen 1",
        "email": "users@users.com",
        "phone": "085732257048",
        "role": "Pelanggan",
      },
      {
        "name": "Agen 1",
        "email": "users@users.com",
        "phone": "085732257048",
        "role": "Pelanggan",
      },
      {
        "name": "Agen 1",
        "email": "users@users.com",
        "phone": "085732257048",
        "role": "Pelanggan",
      },
    ];

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

      // Body halaman daftar pengguna
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daftar Pengguna",
              style: TextStyle(
                fontFamily: "Primary",
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),

            // Filter tombol
            Row(
              children: [
                _buildFilterButton("Semua", true),
                const SizedBox(width: 8),
                _buildFilterButton("Admin", false),
                const SizedBox(width: 8),
                _buildFilterButton("Kurir", false),
                const SizedBox(width: 8),
                _buildFilterButton("Pelanggan", false),
              ],
            ),
            const SizedBox(height: 15),

            // Daftar user
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      color: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            "assets/images/image.png",
                          ),
                        ),
                        title: Text(
                          user["name"],
                          style: const TextStyle(
                            fontFamily: "Primary",
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user["email"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              user["phone"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          width: 90,
                          height: 29,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user["role"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              fontFamily: "Primary",
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Tombol tambah (+)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xffF26D2B),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  // Widget tombol filter
  Widget _buildFilterButton(String text, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? const Color(0xffF26D2B) : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Primary",
          color: isActive ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }
}
