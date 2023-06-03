import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoreWebview extends StatefulWidget {
  const MoreWebview({super.key, required this.url});

  final String url;

  @override
  State<MoreWebview> createState() => _MoreWebviewState();
}

class _MoreWebviewState extends State<MoreWebview> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (context) {
        setState(() {
          isLoading = false;
        });
      }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail News:'),
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : WebViewWidget(controller: controller),
    );
  }
}
