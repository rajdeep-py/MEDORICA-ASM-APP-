import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'widgets/no_connection_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _hasInternet = true;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      _,
    ) {
      _checkConnection();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkConnection({bool setRetrying = false}) async {
    if (setRetrying && mounted) {
      setState(() => _isRetrying = true);
    }

    bool connected = false;
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasNetworkInterface = connectivityResult.any(
        (result) => result != ConnectivityResult.none,
      );

      if (hasNetworkInterface) {
        final lookup = await InternetAddress.lookup('google.com');
        connected = lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
      }
    } catch (_) {
      connected = false;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _hasInternet = connected;
      _isRetrying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router(ref);

    return MaterialApp(
      title: 'ASM App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: _hasInternet
          ? Router.withConfig(config: router)
          : NoConnectionScreen(
              isRetrying: _isRetrying,
              onRetry: () => _checkConnection(setRetrying: true),
            ),
    );
  }
}
