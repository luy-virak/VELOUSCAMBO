import 'package:flutter/material.dart';

class StationSearchBar extends StatelessWidget {
  const StationSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Find a station...',
              hintStyle: TextStyle(color: Color(0xFF8B96A5), fontSize: 16),
              prefixIcon: Icon(Icons.search, color: Color(0xFF8B96A5)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}
