import 'package:flutter/material.dart';
import 'package:peeco/core/core.dart';

class MerchantHomePage extends StatelessWidget {
  const MerchantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: appGradient,
        child: const Center(child: Text('Commerçant Home')),
      ),
    );
  }
}
