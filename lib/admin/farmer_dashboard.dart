import 'dart:io';

import 'package:e_uzhavan/admin/add_product_view.dart';
import 'package:e_uzhavan/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';

import '../auth/login_view.dart' show LoginPage;

class FarmerDashboard extends StatefulWidget {
  final int farmerId;

  const FarmerDashboard({super.key, required this.farmerId});

  @override
  _FarmerDashboardState createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final db = await DatabaseHelper.instance.database;

    final data = await db.query(
      "products",
      where: "farmerId = ?",
      whereArgs: [widget.farmerId],
    );

    setState(() {
      products = data;
    });
  }

  Future<void> deleteProduct(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete("products", where: "id = ?", whereArgs: [id]);

    setState(() {
      products = List.from(products)..removeWhere((element) => element['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean background
      appBar: AppBar(
        title: Text(
          "Farmer Dashboard",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "👨‍🌾 Welcome, Farmer!",
              style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            const SizedBox(height: 12),

            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductScreen(farmerId: widget.farmerId),
                    ),
                  );
                  fetchProducts();
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text("Add Product", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "📦 Your Products",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: products.isEmpty
                  ? Center(
                child: Text(
                  "No products added yet!",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                ),
              )
                  : GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final String imagePath = product['productImage'];

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: imagePath != "default.png" && File(imagePath).existsSync()
                              ? Image.file(
                            File(imagePath),
                            width: double.infinity,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            height: 80,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(Icons.shopping_bag, size: 50, color: Colors.grey),
                          ),
                        ),

                        // Content Section with Expanded to avoid overflow
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['productName'],
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  "💰 ₹${product['productPrice']} | 📦 ${product['productQuantity']}",
                                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                                ),

                                const Spacer(),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      bool? confirmDelete = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text('Are you sure you want to delete this product?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false), // Cancel
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true), // Confirm
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmDelete == true) {
                                        await deleteProduct(product['id']);
                                        fetchProducts(); // Refresh the product list
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Product deleted successfully!')),
                                        );
                                      }
                                    },
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
