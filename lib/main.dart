import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_one/core/services/service_locator.dart';
import 'core/services/service_locator.dart' as service_locator;

import 'config/config.dart';
import 'screens/auth/bloc/auth.dart';

void main() {
  Bloc.observer = SimpleBlocDelegate();
  service_locator.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl()..add(AuthStarted())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.splash,
      ),
    );
  }
}

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // ignore: avoid_print
    print('DEBUG BLOC TRANSITION: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // ignore: avoid_print
    print('DEBUG BLOC ERROR: $error : $stackTrace');
  }
}