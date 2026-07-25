import 'package:flutter/material.dart';

class ProductsSearchBar extends StatelessWidget {
  const ProductsSearchBar({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search for exclusive items...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: const Icon(Icons.search, color: Colors.amber),
        filled: true,
        fillColor: const Color(0xFF1E1E24),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.amber, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.amber, width: 1.5),
        ),
      ),
    );
  }
}
