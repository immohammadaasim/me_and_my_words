// =====================================================================
// ===>> BLOCK DART 1: Main Application Engine & Apps Script WebView <<===
// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MeAndMyWordsApp());
}

// ---------------------------------------------------------------------
// --- Function#1 BLOCK DART 1A: Root App Widget Configuration ---
// ---------------------------------------------------------------------
class MeAndMyWordsApp extends StatelessWidget {
  const MeAndMyWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Me & My Words',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
    );
  }
}
// ---------------------------------------------------------------------
// --- Function#1 END OF BLOCK DART 1A: file : lib/main.dart ---
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// --- Function#2 BLOCK DART 1B: Universal WebView Controller & State ---
// ---------------------------------------------------------------------
class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  double progress = 0;
  bool isLoading = true;

  final String targetUrl = "https://script.google.com/macros/s/AKfycbwBY1IWHhGXnjh7c0SKZV8RMWW8enZg79DOTJ9r0sEhimcVLZ-Otg_u48wGntP189Cv/exec";

  final InAppWebViewSettings settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    domStorageEnabled: true,
    databaseEnabled: true,
    useOnDownloadStart: true,
    mediaPlaybackRequiresUserGesture: false,
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
    isInspectable: true,
    supportZoom: true,
    builtInZoomControls: true,
    displayZoomControls: false,
    useWideViewPort: true,
    loadWithOverviewMode: true,
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        if (webViewController != null && await webViewController!.canGoBack()) {
          webViewController!.goBack();
        } else {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(targetUrl)),
                initialSettings: settings,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    isLoading = true;
                  });
                },
                onProgressChanged: (controller, currentProgress) {
                  setState(() {
                    progress = currentProgress / 100;
                  });
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    isLoading = false;
                  });
                },
                onReceivedError: (controller, request, error) {
                  setState(() {
                    isLoading = false;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url;
                  if (uri != null && !["http", "https", "file", "chrome", "data", "javascript"].contains(uri.scheme)) {
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                  return NavigationActionPolicy.ALLOW;
                },
              ),
              if (isLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
// ---------------------------------------------------------------------
// --- Function#2 END OF BLOCK DART 1B: file : lib/main.dart ---
// ---------------------------------------------------------------------

// =====================================================================
// ===>> END OF BLOCK DART 1 file : lib/main.dart <<===
// =====================================================================