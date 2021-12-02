import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tf/components/loadDialog.dart';
import 'package:tf/utils/webCheckoutArguments.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebCheckoutScreen extends StatefulWidget {
  static String routeName = '/webCheckout';
  @override
  State<WebCheckoutScreen> createState() => _WebCheckoutScreenState();
}

class _WebCheckoutScreenState extends State<WebCheckoutScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as WebCheckoutArguments;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: WebView(
        // initialUrl: args.webUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          webViewController.loadUrl(args.webUrl, headers: {
            'X-Shopify-Customer-Access-Token': args.userAccessToken
          });
        },
        // navigationDelegate: (NavigationRequest request) {
        //     if (request.url.startsWith('https://www.youtube.com/')) {
        //       print('blocking navigation to $request}');
        //       return NavigationDecision.prevent;
        //     }
        //     print('allowing navigation to $request');
        //     return NavigationDecision.navigate;
        //   },
        onPageStarted: (String url) {
          print('Page started loading: $url');
          ShowDialog.show(context);
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
          Navigator.of(context).pop();
        },
        gestureNavigationEnabled: true,
      ),
    );
  }
}
