import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Success Animation
              Image.asset(
                'assets/images/success.jpg', // ✅ Add your Lottie JSON animation
                height: 200,
              ),
              const SizedBox(height: 20),

              // ✅ Order Success Message
              Text(
                "🎉 Order Placed Successfully!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              const SizedBox(height: 10),

              Text(
                "Thank you for shopping with us.\nYour order will be delivered soon.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 30),

              // ✅ Back to Home Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
                  },
                  icon: const Icon(Icons.home, color: Colors.white),
                  label: Text("Back to Home", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
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
      ),
    );
  }
}
