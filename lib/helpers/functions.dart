// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fundz_app/providers/providers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../controllers/utl_controllers.dart';
import '../models/currency.dart';

bool isEmail(String email) {
  String stringWithoutSpaces = email.replaceAll(" ", "");
  const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';

  final regex = RegExp(pattern);

  return regex.hasMatch(stringWithoutSpaces);
}

bool validatePhoneNumber(String phoneNumber) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(patttern);
  if (phoneNumber.isEmpty) {
    return false;
  } else if (!regExp.hasMatch(phoneNumber)) {
    return true;
  }
  return false;
}
void launchUrlNow(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    // 
  }
}

void logout(ref, context) async {
  await Hive.deleteFromDisk();

  final utlController = ref.read(utlControllerProvider.notifier);
  utlController.deleteData('isLoggedIn');
  utlController.deleteData('uid');
  utlController.deleteData('email');
  utlController.deleteData('name');
  utlController.deleteData('access_token');
  utlController.deleteData('refresh_token');
  utlController.deleteData('needsLogOut');
}

void reLogout() {
  final utilityController = UtitlityController();
  utilityController.deleteData('isLoggedIn');
  utilityController.deleteData('uid');
  utilityController.deleteData('email');
  utilityController.deleteData('name');
  utilityController.deleteData('access_token');
  utilityController.deleteData('refresh_token');
  utilityController.deleteData('isVerified');
}

void navigateNamed(BuildContext context, String routName, [Object? arguments]) {
  Navigator.pushNamed(context, routName, arguments: arguments);
}

void navigateToPage(BuildContext context, Widget page, {bool? transistion}) {
  if (transistion != null) {
    Navigator.of(context).push(slideUpPageRoute(page));
  } else {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => page,
      ),
    );
  }
}

void navigateReplacementNamed(BuildContext context, String routName) {
  Navigator.of(context).pushNamedAndRemoveUntil(routName, (route) => false);
}

String convertToAgo(DateTime input) {
  Duration diff = DateTime.now().difference(input);

  if (diff.inDays >= 365) {
    int years = (diff.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} overdue';
  } else if (diff.inDays >= 30) {
    int months = (diff.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} overdue';
  } else if (diff.inDays == 1) {
    return '${diff.inDays} day overdue';
  } else if (diff.inDays > 1) {
    return '${diff.inDays} days overdue';
  } else if (diff.inHours == 1) {
    return '${diff.inHours} hour overdue';
  } else if (diff.inHours > 1) {
    return '${diff.inHours} hours overdue';
  } else if (diff.inMinutes == 1) {
    return '${diff.inMinutes} minute overdue';
  } else if (diff.inMinutes > 1) {
    return '${diff.inMinutes} minutes overdue';
  } else if (diff.inSeconds == 1) {
    return '${diff.inSeconds} second overdue';
  } else if (diff.inSeconds > 1) {
    return '${diff.inSeconds} seconds overdue';
  } else {
    return 'pending';
  }
}

String moneyComma(String data, [String? currency]) {
  String split;
  if (data.contains('.')) {
    var nData = data.split('.');
    if (nData[1].length > 1) {
      split = data;
    } else {
      data += '0';
      split = data;
    }
  } else {
    data += '.00';
    split = data;
  }
  List<String> money;
  if (split.contains('.')) {
    List<String> text = split.split('.');
    String decimalPart = text[1];
    money = text[0].split('');

    if (money.length == 4) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 3) {
      return returnCurrencyAmounth(
          '${money.join('')}.$decimalPart', currency.toString());
    } else if (money.length == 5) {
      String newVariable =
          "${money.sublist(0, 2).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 6) {
      String newVariable =
          "${money.sublist(0, 3).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 7) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(1, 4).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 8) {
      String newVariable =
          "${money.sublist(0, 2).join('')},${money.sublist(2, 5).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 9) {
      String newVariable =
          "${money.sublist(0, 3).join('')},${money.sublist(3, 6).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 10) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(1, 4).join('')},${money.sublist(4, 7).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    }

    return returnCurrencyAmounth(
        '${money.join('')}.$decimalPart', currency.toString());
  } else {
    money = split.split('');
    if (money.length == 4) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 3) {
      return returnCurrencyAmounth(money.join(''), currency.toString());
    } else if (money.length == 5) {
      String newVariable =
          "${money.sublist(0, 2).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 6) {
      String newVariable =
          "${money.sublist(0, 3).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 7) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(1, 4).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 8) {
      String newVariable =
          "${money.sublist(0, 2).join('')},${money.sublist(2, 5).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 9) {
      String newVariable =
          "${money.sublist(0, 3).join('')},${money.sublist(3, 6).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 10) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(1, 4).join('')},${money.sublist(4, 7).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    }

    return returnCurrencyAmounth(money.join(''), currency.toString());
  }
}

String moneyCommaTwo(
  String data, {
  required String? currency,
  required bool? obSecure,
}) {
  String split;
  if (data.contains('.')) {
    var nData = data.split('.');
    if (nData[1].length > 1) {
      split = data;
    } else {
      data += '0';
      split = data;
    }
  } else {
    data += '.00';
    split = data;
  }
  List<String> money;
  if (obSecure != null && obSecure == true) {
    return returnCurrencyAmounth('****', currency!);
  }
  if (split.contains('.')) {
    List<String> text = split.split('.');
    String decimalPart = text[1];
    money = text[0].split('');

    if (money.length == 4) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 3) {
      return returnCurrencyAmounth(
          '${money.join('')}.$decimalPart', currency.toString());
    } else if (money.length == 5) {
      String newVariable =
          "${money.sublist(0, 2).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 6) {
      String newVariable =
          "${money.sublist(0, 3).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 7) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(1, 4).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 8) {
      String newVariable =
          "${money.sublist(0, 2).join('')},${money.sublist(2, 5).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 9) {
      String newVariable =
          "${money.sublist(0, 3).join('')},${money.sublist(3, 6).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    } else if (money.length == 10) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(1, 4).join('')},${money.sublist(4, 7).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(
          "$newVariable.$decimalPart", currency.toString());
    }

    return returnCurrencyAmounth(
        '${money.join('')}.$decimalPart', currency.toString());
  } else {
    money = split.split('');
    if (money.length == 4) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 3) {
      return returnCurrencyAmounth(money.join(''), currency.toString());
    } else if (money.length == 5) {
      String newVariable =
          "${money.sublist(0, 2).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 6) {
      String newVariable =
          "${money.sublist(0, 3).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 7) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(1, 4).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 8) {
      String newVariable =
          "${money.sublist(0, 2).join('')},${money.sublist(2, 5).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 9) {
      String newVariable =
          "${money.sublist(0, 3).join('')},${money.sublist(3, 6).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    } else if (money.length == 10) {
      String newVariable =
          "${money.sublist(0, 1).join('')},${money.sublist(1, 4).join('')},${money.sublist(4, 7).join('')},${money.sublist(money.length - 3).join('')}";

      return returnCurrencyAmounth(newVariable, currency.toString());
    }

    return returnCurrencyAmounth(money.join(''), currency.toString());
  }
}

String returnCurrencyAmounth(String amouth, String currency) {
  switch (currency) {
    case 'dollar':
      return '${returnCurrency(currency)}$amouth';
    default:
      return '${returnCurrency(currency)}$amouth';
  }
}

String returnCurrency(String currency) {
  switch (currency) {
    case 'dollar':
      return '\$';
    case 'rands':
      return 'R';
    case 'cfa':
      return 'CFA';
    default:
      return '₦';
  }
}

extension StringExtension on String {
  String capitalizeAll() {
    List<String> exploded = split(' ');
    List<String> emptyParam = [];
    for (var element in exploded) {
      emptyParam.add(
          "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}");
    }
    return emptyParam.join(' ');
  }

  String unCapitalize() {
    return "${this[0].toLowerCase()}${substring(1).toLowerCase()}";
  }
}

void changeBottomBarColor(bool isDarkMode) {
  if (!isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.lightTheme,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: AppColors.lightTheme,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  } else {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.blackColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.blackTheme,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
}

Locale getCurrentLocale(BuildContext context) {
  // You can also use Localizations.localeOf(context) to get the current locale
  return Localizations.localeOf(context);
}

String regularDateFormat(DateTime dateTime, String currentLocale,
    {bool? removeTime}) {
  DateTime currentDate = DateTime.now();
  String formattedDate;
  if (removeTime != null && removeTime == true) {
    if (currentDate.year > dateTime.year) {
      formattedDate = DateFormat(
              'EEEE: d MMM yyyy', currentLocale == 'hi' ? 'en' : currentLocale)
          .format(dateTime);
    } else {
      formattedDate = DateFormat(
              'EEEE: d MMM', currentLocale == 'hi' ? 'en' : currentLocale)
          .format(dateTime);
    }
  } else {
    if (currentDate.year > dateTime.year) {
      formattedDate = DateFormat('EEEE: d MMM h:mm a yyyy',
              currentLocale == 'hi' ? 'en' : currentLocale)
          .format(dateTime);
    } else {
      formattedDate = DateFormat('EEEE: d MMM h:mm a',
              currentLocale == 'hi' ? 'en' : currentLocale)
          .format(dateTime);
    }
  }
  return formattedDate;
}

String dateFormatter(DateTime dateTime, {bool? removeTime}) {
  DateTime currentDate = DateTime.now();
  String formattedDate;
  if (removeTime != null && removeTime == true) {
    if (currentDate.year > dateTime.year) {
      formattedDate = DateFormat(
        'EEEE: d MMM yyyy',
      ).format(dateTime);
    } else {
      formattedDate = DateFormat(
        'EEEE: d MMM',
      ).format(dateTime);
    }
  } else {
    if (currentDate.year > dateTime.year) {
      formattedDate = DateFormat(
        'EEEE: d MMM h:mm a yyyy',
      ).format(dateTime);
    } else {
      formattedDate = DateFormat(
        'EEEE: d MMM h:mm a',
      ).format(dateTime);
    }
  }
  return formattedDate;
}

int randomInRange(int min, int max) {
  Random random = Random();
  return min + random.nextInt(max - min + 1);
}

void launchEmail(String to, String subject, String body) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: to,
    queryParameters: {
      'subject': subject,
      'body': body,
    },
  );

  await launch(emailLaunchUri.toString());
}

void launchPhoneCall(String phoneNumber) async {
  final Uri phoneCallUri = Uri(scheme: 'tel', path: phoneNumber);

  await launch(phoneCallUri.toString());
}

void launchSMS(String phoneNumber, String message) async {
  final Uri smsLaunchUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
    queryParameters: {'body': message},
  );

  await launch(smsLaunchUri.toString());
}

List<Currency> getCurrencies() {
  return [
    Currency(name: 'naira', symbol: '₦'),
    Currency(name: 'dollar', symbol: '\$'),
    Currency(name: 'cfa', symbol: 'XOF'),
    Currency(name: 'rands', symbol: 'R'),
  ];
}

class Debouncer {
  final Duration delay;
  final VoidCallback callback;
  Timer? _timer;

  Debouncer({required this.delay, required this.callback});

  void onTextChanged(String text) {
    // Cancel the existing timer if the user continues typing
    _timer?.cancel();

    // Start a new timer to execute the callback after the specified delay
    _timer = Timer(delay, () {
      callback();
    });
  }
}

Future<bool> isOnline() async {
  bool result = await InternetConnectionChecker().hasConnection;
  return result;
}

PageRouteBuilder slideUpPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
