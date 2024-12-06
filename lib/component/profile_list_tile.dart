import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  final String leadingText;
  final String subtitle;
  final VoidCallback onPressed;
  const ProfileListTile({
    super.key,
    required this.leadingText,
    required this.onPressed,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            leadingText,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          trailing: IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.edit,
            ),
          ),
        ),
        Divider(
          color: Colors.white,
        )
      ],
    );
  }
}
