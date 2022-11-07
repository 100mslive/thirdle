import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:thirdle/ui/screens/join_screen.dart';
import 'package:uni_links/uni_links.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? roomId, subdomain;

  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      setState(() {
        if (uri != null) {
          roomId = uri.queryParameters["roomId"];
          subdomain = uri.queryParameters["subdomain"];
        }
      });
    }, onError: (Object err) {
      if (!mounted) return;
      showToastWidget(
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Container(
                height: 40,
                width: 200,
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: const Center(
                  child: Text("Link not working!",
                      style: TextStyle(color: Colors.white)),
                )),
          ),
          position: ToastPosition.bottom);
    });
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await getInitialUri();
      if (!mounted) return;
      setState(() {
        if (uri != null) {
          roomId = uri.queryParameters["roomId"];
          subdomain = uri.queryParameters["subdomain"];
        }
      });
    } on Exception {
      showToastWidget(
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Container(
                height: 40,
                width: 200,
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: const Center(
                  child: Text("Link not working!",
                      style: TextStyle(color: Colors.white)),
                )),
          ),
          position: ToastPosition.bottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return JoinScreen(
      roomId: roomId,
      subdomain: subdomain,
    );
  }
}
