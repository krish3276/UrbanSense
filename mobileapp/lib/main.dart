import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/complaint_provider.dart';
import 'routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UrbanSenseApp());
}

class UrbanSenseApp extends StatelessWidget {
  const UrbanSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ComplaintProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final appRouter = AppRouter(authProvider);
          
          return MaterialApp.router(
            title: 'UrbanSense',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}
