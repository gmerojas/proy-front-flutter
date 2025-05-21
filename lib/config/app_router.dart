import 'package:flutter/material.dart';
import 'package:flutter_bloc_one/screens/home/home_screen.dart';
import 'package:flutter_bloc_one/screens/signin/signin_screen.dart';
import 'package:flutter_bloc_one/screens/signup/signup_screen.dart';
import 'package:flutter_bloc_one/screens/splash/splash_screen.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String signin = '/signin';
  static const String signup = '/signup';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case signin:
        return MaterialPageRoute(builder: (_) => SigninScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))));
    }
  }
}