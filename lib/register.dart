import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  bool _isChecked = false; 
  final _formKey = GlobalKey<FormState>();

  String _selectedCountryCode = '+62';
  final List<Map<String, String>> _countries = [
    {'code': '+62', 'name': 'Indonesia', 'flag': 'assets/flags/indonesia.png'},
    {'code': '+1', 'name': 'United States', 'flag': 'assets/flags/us.png'},
    {'code': '+91', 'name': 'India', 'flag': 'assets/flags/india.png'},
  ];

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Success!')),
      );
      Navigator.of(context).pushReplacementNamed('/login');  
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Get Started',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              // Form 
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Nama
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: const TextStyle(fontSize: 15),
                          floatingLabelStyle: TextStyle(color:Colors.yellow.shade600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.transparent),  
                          ),
                          prefixIcon: Icon(Icons.person, color: Colors.grey.shade600),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Nama cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Email
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: const TextStyle(fontSize: 15),
                          floatingLabelStyle: TextStyle(color:Colors.yellow.shade600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.transparent),  
                          ),
                          prefixIcon: Icon(Icons.email, color: Colors.grey.shade600),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Email cannot be empty';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Password
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(fontSize: 15),
                          floatingLabelStyle: TextStyle(color:Colors.yellow.shade600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.transparent),  
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Confirm Password
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: const TextStyle(fontSize: 15),
                          floatingLabelStyle: TextStyle(color:Colors.yellow.shade600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.transparent),  
                          ),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Confirm password cannot be empty';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Nomor Ponsel
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Dropdown Kode Negara
                        Container(
                          width: 80,
                          height: 60, // Set tinggi sama dengan input field nomor telepon
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.transparent),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButtonHideUnderline(
                            child: Align(
                              alignment: Alignment.center, // Pastikan dropdown terpusat vertikal
                              child: DropdownButton<String>(
                                value: _selectedCountryCode,
                                isExpanded: true,
                                isDense: true,
                                items: _countries.map((country) {
                                  return DropdownMenuItem<String>(
                                    value: country['code'],
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          country['flag']!,
                                          width: 28,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            country['name']!,
                                            style: const TextStyle(fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCountryCode = value!;
                                  });
                                },
                                selectedItemBuilder: (BuildContext context) {
                                  return _countries.map((country) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          country['flag']!,
                                          width: 28,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    );
                                  }).toList();
                                },
                                dropdownColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Input Nomor Telepon
                        Expanded(
                          child: SizedBox(
                            height: 60, // Set tinggi input field nomor telepon agar konsisten
                            child: TextFormField(
                              controller: _mobileController,
                              decoration: InputDecoration(
                                prefixText: '$_selectedCountryCode ',
                                prefixStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                labelText: 'Mobile Number',
                                labelStyle: const TextStyle(fontSize: 15),
                                floatingLabelStyle: TextStyle(color: Colors.yellow.shade600),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                prefixIcon: Icon(Icons.phone, color: Colors.grey.shade600),
                                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Mobile phone cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Checkbox Terms & Conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          'I agree to the Bantu.In Terms & Conditions',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Tombol Sign Up
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isChecked ? _register : null, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade600,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
