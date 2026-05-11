import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  // Password Strength State
  double strength = 0;
  String strengthText = "";
  Color strengthColor = Colors.red;

  // Function para sa Password Strength visual guide
  void _checkPassword(String value) {
    String password = value.trim();
    if (password.isEmpty) {
      setState(() { strength = 0; strengthText = ""; });
    } else if (password.length < 6) {
      setState(() { strength = 1/4; strengthText = "Weak (Min. 6 characters)"; strengthColor = Colors.red; });
    } else if (password.length < 10) {
      setState(() { strength = 2/4; strengthText = "Fair"; strengthColor = Colors.orange; });
    } else {
      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
        setState(() { strength = 1; strengthText = "Strong!"; strengthColor = Colors.green; });
      } else {
        setState(() { strength = 3/4; strengthText = "Good (Add symbols for Strong)"; strengthColor = Colors.blue; });
      }
    }
  }

  // Helper function para sa SnackBar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _handleRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // --- VALIDATION LOGIC ---
    
    // 1. Check kung may empty fields
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar("Please fill in all fields", Colors.red);
      return;
    }

    // 2. Email Format Validation (Regex)
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
    ).hasMatch(email);
    
    if (!emailValid) {
      _showSnackBar("Please enter a valid email address", Colors.red);
      return;
    }

    // 3. Password Length Check (Firebase requirement)
    if (password.length < 6) {
      _showSnackBar("Password must be at least 6 characters", Colors.red);
      return;
    }

    // --- PROCEED TO FIREBASE ---
    setState(() => isLoading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    // Siguraduhing ang register method sa AuthProvider ay tumatanggap na ng 3 arguments
    String? result = await auth.register(email, password, name);

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result == "success") {
      _showSnackBar("Account created successfully!", Colors.green);
      Navigator.pop(context); // Balik sa Login
    } else {
      _showSnackBar(result ?? "Registration Failed", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Color(0xFF00ACC1))
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(Icons.person_add_outlined, size: 80, color: Color(0xFFFFA000)),
              const SizedBox(height: 10),
              const Text("Create Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              
              // FULL NAME FIELD
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name', 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.person)
                ),
              ),
              const SizedBox(height: 15),

              // EMAIL FIELD
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email', 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.email)
                ),
              ),
              const SizedBox(height: 15),

              // PASSWORD FIELD
              TextField(
                controller: passwordController,
                obscureText: true,
                onChanged: _checkPassword,
                decoration: const InputDecoration(
                  labelText: 'Password', 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.lock)
                ),
              ),
              const SizedBox(height: 8),

              // STRENGTH INDICATOR UI
              if (passwordController.text.isNotEmpty) ...[
                LinearProgressIndicator(
                  value: strength,
                  backgroundColor: Colors.grey[300],
                  color: strengthColor,
                  minHeight: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      strengthText, 
                      style: TextStyle(color: strengthColor, fontWeight: FontWeight.bold, fontSize: 12)
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 30),

              // REGISTER BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00ACC1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ),
                  onPressed: isLoading ? null : _handleRegister,
                  child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "REGISTER", 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}