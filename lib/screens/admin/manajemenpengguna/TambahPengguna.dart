import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/users_controller.dart';
import 'package:my_app/data/models/users_model.dart';

class Tambahpengguna extends StatefulWidget {
  const Tambahpengguna({super.key, this.userId});
  final int? userId;

  @override
  State<Tambahpengguna> createState() => _TambahpenggunaState();
}

class _TambahpenggunaState extends State<Tambahpengguna> {
  final userController = Get.find<UserController>();

  final namaController = TextEditingController();
  final namaWarungController = TextEditingController();
  final emailController = TextEditingController();
  final teleponController = TextEditingController();
  final passwordController = TextEditingController();

  String? selectedRole = 'customer';
  bool isEditMode = false;
  UserModel? editUser;

  @override
  void initState() {
    super.initState();
    print('USER ID DITERIMA: ${widget.userId}');

    // Ambil argumen user (kalau ada)
    final args = Get.arguments;
    if (args != null && args['user'] != null) {
      editUser = args['user'];
      isEditMode = true;

      // isi form langsung
      namaController.text = editUser?.name ?? '';
      namaWarungController.text = editUser?.otherName ?? '';
      emailController.text = editUser?.email ?? '';
      teleponController.text = editUser?.phone ?? '';
      selectedRole = editUser?.role ?? 'customer';
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    namaWarungController.dispose();
    emailController.dispose();
    teleponController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roles = [
      {'key': 'admin', 'label': 'Admin'},
      {'key': 'courier', 'label': 'Kurir'},
      {'key': 'customer', 'label': 'Pelanggan'},
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
              children: [
                const Text(
                  "Selamat Datang",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 9,
                    fontFamily: "Primary",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  isEditMode ? "Edit Pengguna" : "Tambah Pengguna",
                  style: const TextStyle(
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
      body: Obx(() {
        if (userController.isSubmitting.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
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
                    isEditMode ? "Edit" : "Tambah",
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
              _materialTextField("Alamat Email", emailController),
              const SizedBox(height: 15),
              _materialTextField("Telepon", teleponController),
              const SizedBox(height: 15),

              if (!isEditMode)
                _materialTextField(
                  "Kata Sandi",
                  passwordController,
                  obscureText: true,
                  withEye: true,
                ),

              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role['key'],
                    child: Text(role['label']!),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => selectedRole = val);
                },
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
              const SizedBox(height: 25),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF26D2B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isEditMode ? "Simpan" : "Buat",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 90,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  void _onSubmit() {
    final body = {
      "name": namaController.text,
      "other_name": namaWarungController.text,
      "email": emailController.text,
      "role": selectedRole,
      "phone": teleponController.text,
    };

    if (isEditMode) {
      userController.updateUser(editUser!.id!, body);
    } else {
      body["password"] = passwordController.text;
      userController.createUser(body);
    }
  }

  Widget _materialTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    bool withEye = false,
  }) {
    bool isObscure = obscureText; //Pindah ke luar builder

    return StatefulBuilder(
      builder: (context, setFieldState) {
        return Material(
          elevation: 2,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(8),
          child: TextFormField(
            controller: controller,
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
                      onPressed: () => setFieldState(() {
                        isObscure = !isObscure; //toggle dengan benar
                      }),
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
