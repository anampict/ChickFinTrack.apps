import 'package:flutter/material.dart';

class Detailpengguna extends StatelessWidget {
  const Detailpengguna({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb dan tombol Edit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Pengguna",
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
                      "Detail",
                      style: const TextStyle(
                        fontFamily: "Primary",
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 55,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF26D2B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Primary",
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Card Informasi Pengguna
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Informasi Pengguna",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Primary",
                        fontSize: 14,
                      ),
                    ),
                    const Divider(height: 20),
                    const SizedBox(height: 8),

                    // Isi detail data
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kolom kiri
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _InfoItem(title: "Nama", value: "Admin"),
                            _InfoItem(
                              title: "Alamat Email",
                              value: "admin@admin.com",
                            ),
                            _InfoItem(title: "Peran", value: "Admin"),
                            _InfoItem(
                              title: "Dibuat pada",
                              value: "18/10/2025, 18:00",
                            ),
                          ],
                        ),

                        // Kolom kanan
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _InfoItem(title: "Nama Warung", value: "Tidak ada"),
                            _InfoItem(title: "Telepon", value: "085732257048"),
                            _InfoItem(
                              title: "Email Terverifikasi Pada",
                              value: "18/10/2025, 19:00",
                            ),
                            _InfoItem(
                              title: "Diperbarui pada",
                              value: "18/10/2025, 19:00",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: "Primary",
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: "Primary",
            ),
          ),
        ],
      ),
    );
  }
}
