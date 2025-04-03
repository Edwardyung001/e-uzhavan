import 'package:e_uzhavan/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_success_page.dart';

class OrderDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const OrderDetailsPage({super.key, required this.cartItems});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String paymentMethod = "Cash on Delivery"; // Default payment method

  void placeOrder() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all details")),
      );
      return;
    }

    double totalAmount = widget.cartItems.fold(
        0, (sum, item) => sum + (item['productPrice'] * item['quantity']));

    // Create order data
    Map<String, dynamic> order = {
      'customerName': nameController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'paymentMethod': paymentMethod,
      'status': "Order Placed Successfully", // ✅ Add initial status
    };

    // Insert into database
    await DatabaseHelper.instance.insertOrder(
      nameController.text,
      phoneController.text,
      addressController.text,
      paymentMethod,
      "Order Placed Successfully", // ✅ Pass status here
    );

    // Navigate to success page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OrderSuccessPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text("Order Details", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Shipping Details", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),

            // Phone Number Field
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 10),

            // Address Field
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Delivery Address",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 20),

            // Payment Method Dropdown
            Text("Payment Method", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: paymentMethod,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              items: ["Cash on Delivery", "UPI Payment", "Credit/Debit Card"]
                  .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: placeOrder,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: Text("Place Order", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
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
