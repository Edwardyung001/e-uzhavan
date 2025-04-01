import 'dart:io';
import 'package:e_uzhavan/user/farmer_product_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> farmers;

  const HomeListScreen({Key? key, required this.farmers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (farmers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        itemCount: farmers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FarmerProductsScreen(
                    farmerId: farmers[index]['id'],
                    farmerName: farmers[index]['name'],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFB2DFDB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

                // ✅ Show Farmer's Image if Available, Otherwise Show Default Image
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.green[300],
                  backgroundImage: farmers[index]['profileImage'] != null
                      ? (farmers[index]['profileImage'].startsWith("http")  // ✅ Network Image
                      ? NetworkImage(farmers[index]['profileImage']) as ImageProvider
                      : FileImage(File(farmers[index]['profileImage'])) as ImageProvider)  // ✅ Local Image
                      : const AssetImage("assets/images/default_user.png"), // ✅ Default image
                ),


                title: Text(
                  farmers[index]['name'],
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  farmers[index]['location'],
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
              ),
            ),
          );
        },
      ),
    );
  }
}
