import 'dart:io';
import 'package:e_uzhavan/user/product_details.dart';
import 'package:flutter/material.dart';
import 'package:e_uzhavan/db_helper.dart';
import 'package:google_fonts/google_fonts.dart';


class FarmerProductsScreen extends StatefulWidget {
  final int farmerId;
  final String farmerName;

  const FarmerProductsScreen({super.key, required this.farmerId, required this.farmerName});

  @override
  _FarmerProductsScreenState createState() => _FarmerProductsScreenState();
}

class _FarmerProductsScreenState extends State<FarmerProductsScreen> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts(widget.farmerId);
  }

  Future<void> fetchProducts(int farmerId) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> fetchedProducts = await db.query(
      'products',
      where: 'farmerId = ?',
      whereArgs: [farmerId],
    );

    setState(() {
      products = fetchedProducts;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.farmerName}'s Products",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: products.isEmpty
            ? Center(
          child: Text(
            "No products available!",
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        )
            : GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final String imagePath = product['productImage'];

            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: (imagePath.isNotEmpty && File(imagePath).existsSync())
                        ? Image.file(
                      File(imagePath),
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          product['productName'],
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "₹${product['productPrice']} | Qty: ${product['productQuantity']}",
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(product: products[index]), // ✅ Pass correct product data
                          ),
                        );
                      },
                      child: Text(
                        "View Details",
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
