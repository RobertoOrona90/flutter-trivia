import 'package:flutter/material.dart';
import 'package:trivia/model/ClubModel.dart';

class ClubCardScreen extends StatelessWidget {
  final ClubModel club;
  const ClubCardScreen({super.key, required this.club});

//'https://tmssl.akamaized.net//images/wappen/normquad/418.png?lm=1729684474'
//'Real Madrid '
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(club.image),
              Text(club.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
