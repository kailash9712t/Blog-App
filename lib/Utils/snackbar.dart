import 'package:flutter/material.dart';
class CustomSnackbar {
  void showMessage(BuildContext context,IconData icon, Color color, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(message,softWrap: true,maxLines: 2,overflow: TextOverflow.ellipsis,),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
