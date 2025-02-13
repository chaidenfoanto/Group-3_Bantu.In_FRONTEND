import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front_end/widgets/terms_conditions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();

  String _selectedCountryCode = '+62';
  final List<Map<String, String>> _countries = [
    {'code': '+62', 'name': 'Indonesia', 'flag': 'assets/flags/indonesia.png'},
    {'code': '+1', 'name': 'United States', 'flag': 'assets/flags/us.png'},
    {'code': '+91', 'name': 'India', 'flag': 'assets/flags/india.png'},
  ];

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        // Format phone number for +62
        String phoneNumber = _mobileController.text;
        if (_selectedCountryCode == '+62' && phoneNumber.startsWith('0')) {
          phoneNumber = phoneNumber.substring(1);
        }
        final fullPhoneNumber = _selectedCountryCode + phoneNumber;

        // Make API call
        final response = await http.post(
          Uri.parse('http://192.168.205.117:8000/api/regists'), // Adjust URL as needed
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': _nameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'password_confirmation': _confirmPasswordController.text,
            'no_hp': fullPhoneNumber,
          }),
        );

        // Pop loading dialog
        Navigator.pop(context);

        if (response.statusCode == 201) {
          // Registration successful
          final responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          // Registration failed
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorData['message'] ?? 'Registration failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Handle network/other errors
        Navigator.pop(context); // Hide loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileController.dispose();
    super.dispose();
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
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username field
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: const TextStyle(fontSize: 15),
                          floatingLabelStyle: TextStyle(color: Colors.yellow.shade600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          prefixIcon: Icon(Icons.person, color: Colors.grey.shade600),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Username cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Email field
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: const TextStyle(fontSize: 15),
                          floatingLabelStyle: TextStyle(color: Colors.yellow.shade600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.transparent),
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
                    // Password field
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          labelStyle: const TextStyle(fontSize: 15),
                          floatingLabelStyle: TextStyle(color: Colors.yellow.shade600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          if (value.length < 8) {
                            return 'Your password needs to be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Confirm Password field
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          labelStyle: const TextStyle(fontSize: 15),
                          floatingLabelStyle: TextStyle(color: Colors.yellow.shade600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                        obscureText: !_isConfirmPasswordVisible,
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
                    // Phone number field with country code
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.transparent),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButtonHideUnderline(
                            child: Align(
                              alignment: Alignment.center,
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
                        Expanded(
                          child: SizedBox(
                            height: 60,
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
                                  borderSide: const BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.transparent),
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
                                if (!RegExp(r'^\d+$').hasMatch(value!)) {
                                  return 'Please enter a valid phone number (only numbers)';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Checkbox(
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value ?? false;
                              });
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            side: const BorderSide(
                              color: Colors.transparent,
                              width: 2,
                            ),
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(WidgetState.selected)) {
                                return Colors
                                    .yellow.shade600; // Fillcolor pas selected
                              }
                              return Colors.grey.shade200; // Pas tdk
                            }),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: 'I agree to ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  // fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: "Bantu.In's Terms & Conditions",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.yellow.shade600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final result = await showDialog<bool>(
                                        context: context,
                                        builder: (context) =>
                                            const TermsConditionsDialog(),
                                      );

                                      if (result == true && !_isChecked) {
                                        setState(() {
                                          _isChecked =
                                              true; // Centang checkbox jika belum tercentang
                                        });
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
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
                          shadowColor: Colors.grey.shade300.withOpacity(0.7),
                          elevation: 4,
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