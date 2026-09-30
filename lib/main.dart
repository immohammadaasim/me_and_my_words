// =====================================================================
// ===>> BLOCK DART 1: Main Application Engine & Apps Script WebView <<===
// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌟 1. MICROPHONE PERMISSION INITIALIZER (Prompt OS on App Start)
  try {
    await Permission.microphone.request();
  } catch (e) {
    debugPrint("Permission request notice: $e");
  }

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9500)),
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

  // 🌟 GPU ACCELERATION & ZERO-LAG HIGH PERFORMANCE SETTINGS
  final InAppWebViewSettings settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    domStorageEnabled: true,
    databaseEnabled: true,
    cacheEnabled: true,
    thirdPartyCookiesEnabled: true,
    sharedCookiesEnabled: true,
    mediaPlaybackRequiresUserGesture: false,
    javaScriptCanOpenWindowsAutomatically: true,
    supportMultipleWindows: true,
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
    isInspectable: true,
    supportZoom: true,
    builtInZoomControls: true,
    displayZoomControls: false,
    useWideViewPort: true,
    loadWithOverviewMode: true,
    useHybridComposition: true,
    hardwareAcceleration: true,
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
                // 🌟 MICROPHONE HARDWARE GRANT (Bypasses WebView Mic Block)
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },
                onCreateWindow: (controller, createWindowAction) async {
                  // Allows voice escape micro-window to operate seamlessly
                  return true;
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
                onLoadStop: (controller, url) async {
                  setState(() {
                    isLoading = false;
                  });

                  // 🌟 100% PERSISTENT AUTO-LOGIN ENGINE
                  // Checks and preserves writer session on app close/restart
                  await controller.evaluateJavascript(source: """
                    (function() {
                      try {
                        // 1. Capture credentials on login form submit
                        var form = document.querySelector('form');
                        if (form && !form._autoLoginBound) {
                          form._autoLoginBound = true;
                          form.addEventListener('submit', function() {
                            var u = (document.querySelector('input[name="username"]') || {}).value || '';
                            var p = (document.querySelector('input[name="passcode"]') || {}).value || '';
                            var c = (document.querySelector('input[name="penCode"]') || {}).value || '';
                            if (u && p && c) {
                              localStorage.setItem('__MMW_APK_SESSION_AUTH__', JSON.stringify({ u: u, p: p, c: c }));
                            }
                          });
                        }

                        // 2. If app reopened and on login screen: Auto-Login in 1 tap!
                        var savedAuth = localStorage.getItem('__MMW_APK_SESSION_AUTH__');
                        if (savedAuth && form) {
                          var data = JSON.parse(savedAuth);
                          var uInput = document.querySelector('input[name="username"]');
                          var pInput = document.querySelector('input[name="passcode"]');
                          var cInput = document.querySelector('input[name="penCode"]');
                          if (uInput && pInput && cInput && data.u && data.p && data.c) {
                            uInput.value = data.u;
                            pInput.value = data.p;
                            cInput.value = data.c;
                            form.submit();
                          }
                        }

                        // 3. Clear session storage strictly on explicit user logout
                        var logoutBtns = document.querySelectorAll('#stripLogoutBtn, #confirmLogoutBtn, .logout-btn');
                        logoutBtns.forEach(function(b) {
                          b.addEventListener('click', function() {
                            localStorage.removeItem('__MMW_APK_SESSION_AUTH__');
                          });
                        });
                      } catch(e) {}
                    })();
                  """);
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
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9500)),
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