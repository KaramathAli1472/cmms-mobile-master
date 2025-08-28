// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:maintboard/core/utils/json_utils.dart';

class CategoryResponse {
  final int categoryID;
  final String categoryName;
  final String description;

  CategoryResponse({
    required this.categoryID,
    required this.categoryName,
    required this.description,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      categoryID: requireField<int>(json, 'categoryID'),
      categoryName: requireField<String>(json, 'categoryName'),
      description: requireField<String>(json, 'description'),
    );
  }
}
