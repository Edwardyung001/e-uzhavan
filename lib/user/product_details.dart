import 'dart:io'; // ✅ Import for handling File image
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cart_view.dart' show CartPage;

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1; // Default quantity

  // Function to increase quantity
  void increaseQuantity() {
    int availableQuantity = int.tryParse(widget.product['productQuantity'].toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    if (quantity < availableQuantity){
      setState(() {
        quantity++;
      });
    }
  }


  // Function to decrease quantity (minimum 1)
  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  // Function to handle Buy Now action
  void buyNow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cartItems: [
            {
              'productName': widget.product['productName'],
              'productPrice': widget.product['productPrice'],
              'quantity': quantity,
              'productImage': widget.product['productImage'], // ✅ Pass image
            }
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.product['productImage'] != null && widget.product['productImage'].isNotEmpty
                    ? Image.file(
                  File(widget.product['productImage']), // ✅ Use product image from database
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/default_product.png', height: 200, fit: BoxFit.cover);
                  },
                )
                    : Image.asset(
                  'assets/images/default_product.png', // Default Image
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Product Name
            Text(
              widget.product['productName'],
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            // Product Price & Quantity
            Text(
              "₹${widget.product['productPrice']} | Available: ${widget.product['productQuantity']}",
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: decreaseQuantity,
                  icon: const Icon(Icons.remove_circle, color: Colors.red, size: 30),
                ),
                Text(
                  "$quantity",
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: increaseQuantity,
                  icon: const Icon(Icons.add_circle, color: Colors.green, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buy Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: buyNow,
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: Text(
                  "Buy Now",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

