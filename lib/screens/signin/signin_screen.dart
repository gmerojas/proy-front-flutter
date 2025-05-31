import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_one/config/app_router.dart';
import 'package:flutter_bloc_one/data/repositories/auth_repository.dart';

import '../auth/bloc/auth.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;
    context.read<AuthBloc>().add(
      LoginRequested(LoginParams(username: username, password: password)),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current && (current is Authenticated || current is AuthError),
      listener: (context, state) {
        if(state is Authenticated){
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
        }
        if(state is AuthError){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      Text('SIGNIN SCREEN'),
                      TextField(controller: usernameController),
                      TextField(controller: passwordController),
                      ElevatedButton(
                        onPressed: () => login(context),
                        child: Text('Login'),
                      ),
                      // ElevatedButton(
                      //   onPressed: _loginWithBiometrics, 
                      //   child: Text('Usar Huella Dactilar')
                      // ),
                      // ElevatedButton(
                      //   onPressed: _get2FASetup, 
                      //   child: Text('Generar QR Google Authenticator')
                      // ),
                      // TextField(
                      //   controller: codigoController
                      // ),
                      // ElevatedButton(
                      //   onPressed: _verifyCode, 
                      //   child: Text('Validar codigo')
                      // ),
                    ],
                  ),
                ),
              ),
    );
  }
}