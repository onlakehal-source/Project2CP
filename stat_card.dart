// ignore_for_file: use_key_in_widget_constructors, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peeco/peeco_colors.dart';
import 'package:peeco/peeco_gradient_background.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String trend;
  final Color trendColor;
 
  const StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.trend,
    required this.trendColor,
  });
 
  @override
  Widget build(BuildContext context) {
    return PeecoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: PeecoColors.accentGreen),
              const Spacer(),
              Text(trend,
                  style: TextStyle(
                      color: trendColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: PeecoColors.textPrimary)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: PeecoColors.textSecondary, fontSize: 11, height: 1.3)),
        ],
      ),
    );
  }
}
 