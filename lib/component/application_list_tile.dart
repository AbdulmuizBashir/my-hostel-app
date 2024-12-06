import 'package:flutter/material.dart';

class ApplicationListTile extends StatelessWidget {
  final String leadingText;
  final String trailingText;
  const ApplicationListTile({
    super.key,
    required this.leadingText,
    required this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        leadingText,
        style: TextStyle(
          fontSize: 10,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Text(
        trailingText,
        style: TextStyle(
          fontSize: 10,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
