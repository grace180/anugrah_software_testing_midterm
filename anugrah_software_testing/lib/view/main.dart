import 'package:flutter/material.dart';
import 'package:anugrah_software_testing/viewmodel/authViewModel.dart';

class HomeScreen extends StatelessWidget {
  final AuthViewModel viewModel;

  HomeScreen({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await viewModel.logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(child: Text('Welcome ${viewModel.user?.username}')),
    );
  }
}