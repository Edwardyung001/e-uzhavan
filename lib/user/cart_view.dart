import 'dart:io'; // ✅ Import for handling file images
import 'package:e_uzhavan/user/order_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty", style: TextStyle(fontSize: 18)))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            String imagePath = cartItems[index]['productImage']; // ✅ Get image path

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: imagePath.isNotEmpty && File(imagePath).existsSync()
                    ? Image.file(
                  File(imagePath), // ✅ Convert String to File safely
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : Image.asset('assets/images/default_product.png', width: 50, height: 50, fit: BoxFit.cover),
                title: Text(cartItems[index]['productName'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                subtitle: Text("₹${cartItems[index]['productPrice']} x ${cartItems[index]['quantity']}"),
                trailing: const Icon(Icons.delete, color: Colors.red),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailsPage(cartItems: cartItems), // ✅ Navigate to Order Page
              ),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: const EdgeInsets.all(12)),
          child: Text("Checkout", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
