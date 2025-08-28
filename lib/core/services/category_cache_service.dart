// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/models/work_order/category_response.dart';
import 'package:maintboard/core/services/category_service.dart';

class CategoryCacheService {
  // Singleton Instance
  CategoryCacheService._internal();
  static final CategoryCacheService _instance =
      CategoryCacheService._internal();
  factory CategoryCacheService() => _instance;

  // In-memory cache for categories
  List<CategoryResponse> _categories = [];

  /// Loads categories from a list
  void loadCategories(List<CategoryResponse> categories) {
    _categories = categories;
  }

  /// Loads categories from the API
  Future<void> loadCategoriesFromService() async {
    final categories = await CategoryService().fetchCategoryList();
    loadCategories(categories);
  }

  /// Checks if the cache is populated
  bool hasData() => _categories.isNotEmpty;

  /// Fetches all categories
  List<CategoryResponse> getCategories() => _categories;

  static final CategoryResponse unknownCategory = CategoryResponse(
    categoryID: -1,
    categoryName: "Unknown",
    description: "Category not found",
  );

  /// Fetches a category by ID
  CategoryResponse getCategoryByID(int categoryID) {
    return _categories.firstWhere(
      (category) => category.categoryID == categoryID,
      orElse: () => unknownCategory, // Returns a default category
    );
  }

  /// Clears the category cache
  void clearCache() {
    _categories = [];
  }
}
