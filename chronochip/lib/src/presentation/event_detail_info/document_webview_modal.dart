import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentWebViewModal extends StatefulWidget {
  final String url;
  const DocumentWebViewModal({Key? key, required this.url}) : super(key: key);

  @override
  State<DocumentWebViewModal> createState() => _DocumentWebViewModalState();
}

class _DocumentWebViewModalState extends State<DocumentWebViewModal> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setBackgroundColor(const Color(0xFFFFFFFF));
    // set a common browser user-agent to avoid servers blocking webview user agents
    try {
      _controller.setUserAgent(
        'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Mobile Safari/537.36',
      );
    } catch (_) {}
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          debugPrint('WebView onPageStarted: $url');
          setState(() {
            _isLoading = true;
            _error = null;
          });
        },
        onPageFinished: (url) {
          debugPrint('WebView onPageFinished: $url');
          setState(() {
            _isLoading = false;
          });
        },
        onWebResourceError: (err) {
          debugPrint(
            'WebView onWebResourceError: ${err.errorCode} ${err.description}',
          );
          setState(() {
            _isLoading = false;
            _error = err.description;
          });
        },
      ),
    );
    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(widget.url),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Colors.black87,
              elevation: 1,
              actions: [
                IconButton(
                  icon: const Icon(Icons.open_in_browser),
                  onPressed: () async {
                    // open external browser
                    final uri = Uri.tryParse(widget.url);
                    if (uri != null) {
                      // Use launchUrl if package available; fallback: copy to clipboard
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (_error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Error cargando página',
                              style: TextStyle(color: Colors.red[700]),
                            ),
                            const SizedBox(height: 8),
                            Text(_error ?? '', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
