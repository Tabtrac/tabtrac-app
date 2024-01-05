// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/colors.dart';
import '../../helpers/functions.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://tabtrac.vercel.app/terms'),
      );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final transH = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.arrow_left,
            color: AppColors.primaryColor,
          ),
        ),
        title: FittedBox(
          child: Text(
            transH.termsAndConditions.capitalizeAll(),
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          NavigationControls(controller: controller),
          Menu(controller: controller),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
            await controller.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: Container(
          height: height,
          width: width,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: WebViewStack(controller: controller),
        ),
      ),
    );
  }
}

// Stack
class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key}); // MODIFY

  final WebViewController controller; // ADD

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (navigation) {
            final host = Uri.parse(navigation.url).host;
            if (host.contains('youtube.com')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Blocking navigation to $host',
                  ),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
            color: AppColors.primaryColor,
          ),
      ],
    );
  }
}

// Navigation Control Button
class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    'No back history item',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    'No forward history item',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              );
              return;
            }
          },
        ),
      ],
    );
  }
}

enum _MenuOptions {
  navigationDelegate,
  reload,
}

// Menu Buttons
class Menu extends StatelessWidget {
  const Menu({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          case _MenuOptions.navigationDelegate:
            launchUrlNow('https://tabtrac.vercel.app/terms');
            break;
          case _MenuOptions.reload:
            controller.reload();
            break;
        }
      },
      color: Theme.of(context).scaffoldBackgroundColor,
      itemBuilder: (context) => [
        PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.navigationDelegate,
          child: Text(
            'Open in browser',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ),
        PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.reload,
          child: Text(
            'Reload',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ),
      ],
    );
  }
}
