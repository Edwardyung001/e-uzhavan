import 'dart:io';
import 'package:e_uzhavan/auth/login_view.dart';
import 'package:e_uzhavan/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController locationController = TextEditingController(); // ✅ Added Location Controller

  String role = "User";
  File? _selectedImage;

  // ✅ Pick Image from Gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // ✅ Signup Function
  Future<void> signup(String name, String email, String password, String role, String? location, String? profileImage) async {
    final db = await DatabaseHelper.instance.database;

    // Check if email already exists
    final existingUser = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUser.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email already exists. Please use a different email.")),
      );
      return;
    }

    int userId;

    if (role == 'Farmer') {
      // ✅ Insert Farmer with Location & Image
      userId = await db.insert('users', {
        'name': name,
        'role': role,
        'location': location, // ✅ Store location for Farmers
        'email': email,
        'password': password,
        'profileImage': profileImage ?? "/path/to/default/farmer_image.png", // ✅ Default image if null
      });

      // ✅ Update farmerId (Set it same as user ID)
      await db.update(
        'users',
        {'farmerId': userId}, // ✅ Assign `farmerId` same as `id`
        where: 'id = ?',
        whereArgs: [userId],
      );
    } else {
      // ✅ Insert User with Default Image (No location)
      userId = await db.insert('users', {
        'name': name,
        'role': role,
        'email': email,
        'password': password,
        'profileImage': "assets/images/default_user.png", // ✅ Default image for Users
        'location': null, // ✅ No location for Users
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Signup successful! Please login.")),
    );

    // Navigate to login page
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/signup.jpg', height: 180),
              const SizedBox(height: 20),
              const Text("Create an Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Name Field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF57E3A6)),
                  labelText: "Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),

              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF57E3A6)),
                  labelText: "Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF57E3A6)),
                  labelText: "Password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),

              // Role Selection Dropdown
              DropdownButtonFormField<String>(
                value: role,
                onChanged: (String? newValue) {
                  setState(() {
                    role = newValue!;
                  });
                },
                items: ["User", "Farmer"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF57E3A6)),
                ),
              ),
              const SizedBox(height: 10),

              // ✅ Location Field (Only for Farmers)
              if (role == "Farmer") ...[
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                    labelText: "Location",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // ✅ Show Image Picker Only for Farmers
              if (role == "Farmer") ...[
                _selectedImage != null
                    ? Image.file(_selectedImage!, height: 100) // Show Selected Image
                    : const Text("No Image Selected"),

                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text("Pick Image", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Signup Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      signup(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        role,
                        role == "Farmer" ? locationController.text.trim() : null, // ✅ Only Farmers need location
                        role == "Farmer" ? _selectedImage?.path : null, // ✅ Farmers need image
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                    }
                  },
                  child: const Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),

              // Navigate to Login
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>  LoginPage())),
                    child: const Text("Login", style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
