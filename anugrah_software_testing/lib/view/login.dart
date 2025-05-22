// import 'package:flutter/material.dart';
// import 'package:anugrah_software_testing/viewmodel/authViewModel.dart';
// import 'main.dart';

// class LoginScreen extends StatelessWidget {
//   final AuthViewModel viewModel;

//   LoginScreen({required this.viewModel});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(labelText: 'Username'),
//               onChanged: (value) => viewModel.validateUsername(value),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//               onChanged: (value) => viewModel.validatePassword(value),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await viewModel.login('username', 'password');
//                 if (viewModel.user != null) {
//                   // Navigator.pushReplacement(
//                   //   context,
//                   //   MaterialPageRoute(builder: (_) => HomeScreen()),
//                   // );
//                 }
//               },
//               child: Text('Login'),
//             ),
//             if (viewModel.errorMessage != null)
//               Text(viewModel.errorMessage!, style: TextStyle(color: Colors.red)),
//           ],
//         ),
//       ),
//     );
//   }
// }