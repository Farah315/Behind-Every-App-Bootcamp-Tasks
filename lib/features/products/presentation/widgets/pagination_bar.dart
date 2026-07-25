import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage > 1 ? onPrevious : null,
          icon: const Icon(Icons.chevron_left),
          color: Colors.amber,
          disabledColor: Colors.white24,
        ),
        Text(
          '$currentPage / $totalPages',
          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
        ),
        IconButton(
          onPressed: currentPage < totalPages ? onNext : null,
          icon: const Icon(Icons.chevron_right),
          color: Colors.amber,
          disabledColor: Colors.white24,
        ),
      ],
    );
  }
}
