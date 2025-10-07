import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs; // nilai index yang bisa didengar UI

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
