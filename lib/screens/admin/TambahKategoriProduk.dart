import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TambahkategoriProduk extends StatelessWidget {
  const TambahkategoriProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
            padding: EdgeInsets.only(top: 17, left: 20),
            child: Text(
              "Kategori",
              style: TextStyle(
                fontFamily: "Primary",
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          //card 1
          Padding(
            padding: EdgeInsets.only(top: 13, left: 10, right: 10),
            child: Card(
              elevation: 2,
              color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      Card(
                        color: Color(0xffFFB02E),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/kategoriproduk.svg",
                              width: 39,
                              height: 39,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Ayam Broiler",
                        style: TextStyle(
                          fontFamily: "Second",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          print("Icon edit diklik!");
                        },
                        child: Padding(
                          padding: EdgeInsets.all(
                            8,
                          ), // biar area klik lebih luas
                          child: SvgPicture.asset(
                            "assets/icons/edit.svg",
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              
            ),
          ),

          //card 2
          Padding(
            padding: EdgeInsets.only(top: 13, left: 10, right: 10),
            child: Card(
              elevation: 2,
              color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      Card(
                        color: Color(0xffFFB02E),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/kategoriproduk.svg",
                              width: 39,
                              height: 39,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Ayam Pejantan",
                        style: TextStyle(
                          fontFamily: "Second",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          print("Icon edit diklik!");
                        },
                        child: Padding(
                          padding: EdgeInsets.all(
                            8,
                          ), // biar area klik lebih luas
                          child: SvgPicture.asset(
                            "assets/icons/edit.svg",
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              
            ),
          ),
        ],
      ),
      // Tambahkan FAB di bawah kanan
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          print("Tambah kategori diklik!");
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
