import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/utl_controllers.dart';

class ThemeState extends StateNotifier<bool> {
  ThemeState() : super(true);
  final utitlityController = UtitlityController();
  void changeTheme(bool theme) {
    if (theme) {
      utitlityController.writeData('darkMode', 'yes');
    } else {
      utitlityController.writeData('darkMode', 'no');
    }
    state = theme;
  }
}
