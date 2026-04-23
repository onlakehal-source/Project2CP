import 'package:flutter/material.dart';
import 'package:peeco/core/core.dart';

class ClientHome extends StatelessWidget {
  const ClientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: appGradient,
        child: const Center(
          child: Text(
            'Client Home',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
