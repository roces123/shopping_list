import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _handleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    // 1. Tinatawag ang login method (Async task)
    String? result = await auth.login(
      emailController.text.trim(), 
      passwordController.text.trim()
    );

    // 2. ETO ANG FIX: Check kung "mounted" pa ang widget bago gamitin ang context
    if (!mounted) return;

    if (result == "success") {
      // Success! Kusa na itong lilipat dahil sa RootHandler
    } else {
      // Dito na lalabas ang error kapag mali ang password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? "Login Failed"), 
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // Mas modern tingnan
        ),
      );
    }
  }

  @override
  void dispose() {
    // Para hindi mag-leak ang memory (Clean Code point!)
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView( // Para hindi mag-error kapag lumabas ang keyboard
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80), // Offset para sa center look
              const Icon(Icons.lock_outline, size: 100, color: Color(0xFF00ACC1)),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress, // Better mobile UX
                decoration: const InputDecoration(
                  labelText: 'Email', 
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password', 
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA000)),
                  onPressed: _handleLogin,
                  child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text("Don't have an account? Register here", style: TextStyle(color: Color(0xFF00ACC1))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}