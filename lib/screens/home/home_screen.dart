import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_one/config/app_router.dart';

import '../auth/bloc/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '¡Bienvenido {state.user.name} {state.user.lastname}!',
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogout());
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.signin,
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text('HOME SCREEN'),
      ),
    );
  }
}