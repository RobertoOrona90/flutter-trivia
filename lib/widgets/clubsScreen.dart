import 'package:flutter/material.dart';

class ClubsScreen extends StatelessWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Color color = Colors
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
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
        ),
        Image.network(
            'https://tmssl.akamaized.net//images/wappen/normquad/7055.png?lm=1673098434'),
        Image.network(
            'https://tmssl.akamaized.net//images/wappen/homepageWappen150x150/2407.png?lm=1406966074'),
      ],
    );
  }
}
