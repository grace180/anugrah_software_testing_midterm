import 'package:flutter/material.dart';
import 'package:anugrah_software_testing/viewmodel/authViewModel.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  final AuthViewModel viewModel;

  const HomeScreen({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await viewModel.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(viewModel: viewModel),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (viewModel.currentUser != null) ...[
              CircleAvatar(
                backgroundImage: NetworkImage(viewModel.currentUser!.image),
                radius: 50,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome, ${viewModel.currentUser!.firstName} ${viewModel.currentUser!.lastName}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),  
              ),
              Text('@${viewModel.currentUser!.username}'),
            ],
          ],
        ),
      ),
    );
  }
}