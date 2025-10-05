import 'package:flutter/material.dart';

class Buatpesanan extends StatefulWidget {
  const Buatpesanan({super.key});

  @override
  State<Buatpesanan> createState() => _BuatpesananState();
}

class _BuatpesananState extends State<Buatpesanan> {
  //pelanggan
  String? selectedPelanggan;
  final List<String> dummyPelanggan = [
    'Pelanggan A',
    'Pelanggan B',
    'Pelanggan C',
  ];
  //alamat
  String? selectedAlamat;

  final List<String> dummyAlamat = ['Kluwut', 'Lebaksari', 'Kedawung'];

  //kurir
  String? selectedKurir;
  final List<String> dummyKurir = ['Muhib', 'Dhani', 'Ahmed'];

  //tanggal
  DateTime selectedDate = DateTime.now();
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

            // pelanggan
            const Padding(
              padding: EdgeInsets.only(top: 30, left: 28, right: 28),
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

            // Dropdown biasa
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(8),
                child: DropdownMenu<String>(
                  width: MediaQuery.of(context).size.width - 56,
                  initialSelection: selectedPelanggan,
                  leadingIcon: const Icon(Icons.person_outline),
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                  ),
                  hintText: "Pilih Pelanggan",
                  onSelected: (value) {
                    setState(() {
                      selectedPelanggan = value;
                    });
                  },
                  dropdownMenuEntries: dummyPelanggan.map((pelanggan) {
                    return DropdownMenuEntry(
                      value: pelanggan,
                      label: pelanggan,
                    );
                  }).toList(),
                ),
              ),
            ),
            //alamat pengiriman
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
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
            // Dropdown biasa
            Padding(
              padding: const EdgeInsets.only(top: 9, left: 28, right: 28),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(8),
                child: DropdownMenu<String>(
                  width: MediaQuery.of(context).size.width - 56,
                  initialSelection: selectedAlamat,
                  leadingIcon: const Icon(Icons.person_outline),
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                  ),
                  hintText: "Pilih Alamat Pengiriman",
                  onSelected: (value) {
                    setState(() {
                      selectedAlamat = value;
                    });
                  },
                  dropdownMenuEntries: dummyAlamat.map((alamat) {
                    return DropdownMenuEntry(value: alamat, label: alamat);
                  }).toList(),
                ),
              ),
            ),
            //kurir dan tanggal
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
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(8),
                          child: DropdownMenu<String>(
                            width: double.infinity,
                            initialSelection: selectedKurir,
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
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            hintText: 'Pilih Kurir',
                            onSelected: (value) {
                              setState(() {
                                selectedKurir = value;
                              });
                            },
                            dropdownMenuEntries: dummyKurir.map((kurir) {
                              return DropdownMenuEntry(
                                value: kurir,
                                label: kurir,
                              );
                            }).toList(),
                          ),
                        ),
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
          ],
        ),
      ),
    );
  }
}
