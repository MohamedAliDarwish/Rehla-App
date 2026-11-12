import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/routes/app_route.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      title: AppStrings.appName,
      routerConfig: AppRouter.router,
    );
  }
}
