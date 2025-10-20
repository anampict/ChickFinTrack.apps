import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class Tambahpengguna extends StatelessWidget {
  const Tambahpengguna({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController namaWarungController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController teleponController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController tanggalController = TextEditingController(
      text:
          "${DateTime.now().day.toString().padLeft(2, '0')}/"
          "${DateTime.now().month.toString().padLeft(2, '0')}/"
          "${DateTime.now().year} ${TimeOfDay.now().format(context)}",
    );

    String? selectedRole = 'Pelanggan';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  "Tambah",
                  style: const TextStyle(
                    fontFamily: "Primary",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _materialTextField("Nama", namaController),
            const SizedBox(height: 15),
            _materialTextField("Nama Warung", namaWarungController),
            const SizedBox(height: 15),
            _materialTextField(
              "Alamat Email",
              emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            _materialTextField(
              "Telepon",
              teleponController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            _materialTextField(
              "Kata Sandi",
              passwordController,
              obscureText: true,
              withEye: true,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Material(
                    elevation: 2,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                    child: DropdownButtonFormField<String>(
                      value: selectedRole,
                      items: const [
                        DropdownMenuItem(
                          value: 'Pelanggan',
                          child: Text('Pelanggan'),
                        ),
                        DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                      ],
                      onChanged: (val) {},
                      decoration: InputDecoration(
                        labelText: "Peran",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Material(
                    elevation: 2,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                    child: TextFormField(
                      controller: tanggalController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Tanggal Pembuatan",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              final selectedDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time?.hour ?? 0,
                                time?.minute ?? 0,
                              );
                              tanggalController.text =
                                  "${selectedDateTime.day.toString().padLeft(2, '0')}/"
                                  "${selectedDateTime.month.toString().padLeft(2, '0')}/"
                                  "${selectedDateTime.year} "
                                  "${TimeOfDay.fromDateTime(selectedDateTime).format(context)}";
                            }
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Submit form
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF26D2B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets
                          .zero, // penting biar ukuran sesuai SizedBox
                    ),
                    child: const Text(
                      "Buat",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      navigator!.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets
                          .zero, // penting biar ukuran sesuai SizedBox
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _materialTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    bool withEye = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isObscure = obscureText;
        return Material(
          elevation: 2,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(8),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isObscure,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.white,
              suffixIcon: withEye
                  ? IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        );
      },
    );
  }
}
