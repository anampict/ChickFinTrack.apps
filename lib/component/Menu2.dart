import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Menu2 extends StatelessWidget {
  const Menu2({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildMenu2("assets/icons/box.svg", "Produk");
  }

  Widget _buildMenu2(String iconPath, String label) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.8,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.all(16),
      children: [
        _buildCard(
          title: "Produk",
          value: "10",
          subtitle: "Tersedia",
          subtitleColor: Colors.orange,
          icon: "assets/icons/produk.svg",
          color: Colors.orange,
        ),
        _buildCard(
          title: "Pelanggan",
          value: "26",
          subtitle: "Terdaftar",
          subtitleColor: Colors.green,
          icon: "assets/icons/pelanggan.svg",
          color: Colors.green,
        ),
        _buildCard(
          title: "Pesanan",
          value: "37",
          subtitle: "+0.0%",
          subtitleColor: Colors.green,
          icon: "assets/icons/kurvapesanan.svg",
          color: Colors.green,
        ),
        _buildCard(
          title: "Revenue",
          value: "Rp. 82,8 Jt",
          subtitle: "+0.0%",
          subtitleColor: Colors.green,
          icon: "assets/icons/kurvapesanan.svg",
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required String subtitle,
    required Color subtitleColor,
    required String icon,
    required Color color,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                ),
                SvgPicture.asset(
                  icon,
                  width: 18,
                  height: 18,
                  color: color,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}