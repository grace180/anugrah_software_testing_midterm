import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anugrah_software_testing/model/authService.dart';
import 'package:anugrah_software_testing/viewmodel/authViewModel.dart';
import 'view/login.dart';
import 'view/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider(
        create: (_) => AuthViewModel(authService: AuthService()), 
        child: Consumer<AuthViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.currentUser == null) {
              return LoginScreen(viewModel: viewModel);
            } else {
              return HomeScreen(viewModel: viewModel);
            }
          },
        ),
      ),
    );
  }
}