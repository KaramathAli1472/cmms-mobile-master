// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/core/models/work_order/category_response.dart';
import 'package:maintboard/core/services/category_cache_service.dart';

class CategoryDropdown extends StatefulWidget {
  final CategoryResponse? selectedCategory;
  final ValueChanged<CategoryResponse?> onChanged;
  final String? Function(CategoryResponse?)? validator;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
    this.validator,
  });

  @override
  CategoryDropdownState createState() => CategoryDropdownState();
}

class CategoryDropdownState extends State<CategoryDropdown> {
  List<CategoryResponse> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      // Load categories from the cache service
      await CategoryCacheService().loadCategoriesFromService();
      final loadedCategories = CategoryCacheService().getCategories();

      if (!mounted) return; // Ensure widget is still active

      setState(() {
        categories = loadedCategories;
        if (widget.selectedCategory == null && loadedCategories.isNotEmpty) {
          widget.onChanged(loadedCategories.first);
        }
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // Ensure widget is still active
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DropdownButtonFormField<CategoryResponse>(
      decoration: const InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(),
      ),
      value: widget.selectedCategory,
      items: categories.map((category) {
        return DropdownMenuItem<CategoryResponse>(
          value: category,
          child: Text(category.categoryName),
        );
      }).toList(),
      onChanged: widget.onChanged,
      validator: widget.validator ??
          (value) => value == null ? 'Please select a category' : null,
    );
  }
}
