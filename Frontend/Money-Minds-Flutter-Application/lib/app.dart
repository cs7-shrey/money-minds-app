import 'package:financeseekho/common/theme_provider.dart';
import 'package:financeseekho/features/Authentication/Screens/LoginScreen/LoginScreen.dart';
import 'package:financeseekho/features/Authentication/Screens/SignupScreen/SignupScreen.dart';
import 'package:financeseekho/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'utils/helper/helper_functions.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.theme,
          theme: FAppTheme.lightTheme,
          darkTheme: FAppTheme.darkTheme,
          home: const LoginScreen(),
        );
      }
    );
  }
}
