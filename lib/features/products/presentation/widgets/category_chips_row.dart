import 'package:flutter/material.dart';

import '../../domain/entities/category_entity.dart';

class CategoryChipsRow extends StatelessWidget {
  const CategoryChipsRow({
    super.key,
    required this.categories,
    required this.selectedSlug,
    required this.onSelected,
  });

  final List<CategoryEntity> categories;
  final String? selectedSlug;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1, // +1 for "All"
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final isSelected = isAll ? selectedSlug == null : selectedSlug == categories[index - 1].slug;
          final label = isAll ? 'All' : categories[index - 1].name;

          return GestureDetector(
            onTap: () => onSelected(isAll ? null : categories[index - 1].slug),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.amber : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                if (isSelected)
                  Container(width: 20, height: 2, color: Colors.amber),
              ],
            ),
          );
        },
      ),
    );
  }
}
