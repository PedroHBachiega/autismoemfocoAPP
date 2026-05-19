import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'theme/theme_provider.dart';
import 'providers/gamification_provider.dart';
import 'router/app_router.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 1. Movemos os Providers para cá! 
  // Eles envolvem o MyApp, então o MyApp pode ler o AuthProvider no initState.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => GamificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 2. O roteador agora é criado uma única vez aqui
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Como o Provider está acima de MyApp agora, isso funciona perfeitamente:
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _router = createRouter(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    // 3. O MaterialApp agora só escuta o ThemeProvider
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp.router(
          title: 'Autismo em Foco',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          routerConfig: _router, // A mesma instância, sempre!
        );
      },
    );
  }
}