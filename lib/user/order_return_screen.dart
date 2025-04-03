import 'package:e_uzhavan/db_helper.dart';
import 'package:flutter/material.dart';

class ReturnOrderForm extends StatefulWidget {
  final int orderId;
  final Function(int, String) onReturnSubmitted; // Callback function

  const ReturnOrderForm({super.key, required this.orderId, required this.onReturnSubmitted});

  @override
  _ReturnOrderFormState createState() => _ReturnOrderFormState();
}

class _ReturnOrderFormState extends State<ReturnOrderForm> {
  final TextEditingController _reasonController = TextEditingController();

  Future<void> submitReturnRequest() async {
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a return reason")),
      );
      return;
    }

    await DatabaseHelper.instance.updateOrderStatus(widget.orderId, "Returning");

    widget.onReturnSubmitted(widget.orderId, "Returning");

    // ✅ Instead of pushing a new screen, just pop back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Return Order")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Enter return reason:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type your reason here...",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitReturnRequest,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
