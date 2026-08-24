// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  const CircleWidget({super.key, required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.network(
            'https://utyug.info/upload/iblock/e2b/e2bc0ec35a53dedd8c0173b5443ea9c9.jpg',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade800,
                child: const Icon(Icons.person, color: Colors.white),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
