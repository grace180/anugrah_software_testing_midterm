import 'package:flutter/material.dart';
import 'package:anugrah_software_testing/viewmodel/authViewModel.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  final AuthViewModel viewModel;
  
  const LoginScreen({Key? key, required this.viewModel}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) => widget.viewModel.validateUsername(value ?? ''),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => widget.viewModel.validatePassword(value ?? ''),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: widget.viewModel.isLoading ? null : _handleLogin,
                child: widget.viewModel.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
              if (widget.viewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    widget.viewModel.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await widget.viewModel.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (widget.viewModel.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(viewModel: widget.viewModel),
          ),
        );
      }
    }
  }
}