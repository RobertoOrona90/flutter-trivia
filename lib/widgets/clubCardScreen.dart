import 'package:flutter/material.dart';

class ClubCardScreen extends StatelessWidget {
  const ClubCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Card(
          elevation: 5,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                    'https://tmssl.akamaized.net//images/wappen/normquad/418.png?lm=1729684474'),
                const Text(
                  'Real Madrid ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
  }
}