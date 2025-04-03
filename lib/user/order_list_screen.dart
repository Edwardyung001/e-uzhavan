import 'package:e_uzhavan/user/order_return_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_uzhavan/db_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when screen loads
  }

  Future<void> fetchOrders() async {
    final data = await DatabaseHelper.instance.getOrders(); // Fetch from DB
    setState(() {
      orders = List<Map<String, dynamic>>.from(data); // ✅ Ensure list is mutable
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Order List", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      //   backgroundColor: Colors.green[700],
      // ),
      body: orders.isEmpty
          ? const Center(child: Text("No orders found", style: TextStyle(fontSize: 18)))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order['customerName'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Phone: ${order['phone']}"),
                  Text("Address: ${order['address']}"),

                  Text("Payment: ${order['paymentMethod']}", style: const TextStyle(color: Colors.green)),
                  Text(
                    "Order Status: ${order['status']}",
                    style: TextStyle(
                      color: order['status'] == "Returning" ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
if(order['status'] != "Returning")
                  // Buttons Row (Cancel & Return)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          bool? confirmDelete = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm Deletion"),
                                content: const Text("Are you sure you want to delete this order?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmDelete == true) {
                            await DatabaseHelper.instance.deleteOrder(order['id']); // ✅ Delete from DB
                            setState(() {
                              orders = List.from(orders); // ✅ Ensure list is mutable
                              orders.removeAt(index); // ✅ Remove from list
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Order deleted successfully")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text("Cancel Order", style: GoogleFonts.poppins(color: Colors.white)),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReturnOrderForm(
                                orderId: order['id'],
                                onReturnSubmitted: (id, newStatus) {
                                  setState(() {
                                    int orderIndex = orders.indexWhere((o) => o['id'] == id);
                                    if (orderIndex != -1) {
                                      orders = List.from(orders); // ✅ Ensure list is mutable
                                      orders[orderIndex] = Map<String, dynamic>.from(orders[orderIndex]) // ✅ Copy order
                                        ..['status'] = newStatus; // ✅ Update status
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                        child: Text("Return Order", style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
