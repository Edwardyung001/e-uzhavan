import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> services = [
      {"icon": Icons.agriculture, "title": "Agriculture Services"},
      {"icon": Icons.local_grocery_store, "title": "Market Access"},
      {"icon": Icons.warehouse, "title": "Storage Solutions"},
      {"icon": Icons.support, "title": "Farmer Support"},
    ];

    return Scaffold(
      backgroundColor: Colors.green[50],

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(services[index]['icon'], size: 50, color: Colors.green[700]),
                  const SizedBox(height: 10),
                  Text(
                    services[index]['title'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
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
