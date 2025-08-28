// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:maintboard/core/models/part/part_response.dart';
import 'package:maintboard/core/services/part_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';

class PartDropdown extends StatelessWidget {
  final ValueChanged<PartResponse?> onChanged;
  final PartResponse? selectedPart;
  final String? Function(PartResponse?)? validator;

  const PartDropdown({
    super.key,
    required this.onChanged,
    this.selectedPart,
    this.validator,
  });

  Future<List<PartResponse>> fetchParts(
      String? filter, LoadProps? loadProps) async {
    final int skip = loadProps?.skip ?? 0;
    final int take = loadProps?.take ?? 20;

    try {
      final int? siteID = await SharedPreferenceService.getCurrentSiteID();
      return await PartService().fetchPartList(
        queryParams: {
          'siteID': siteID,
          'searchTerm': filter,
          'rowsPerPage': take,
          'pageNumber': skip ~/ take,
          'sort': 'PartName_ASC',
        },
      );
    } catch (e) {
      SnackbarService.showError(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<PartResponse>(
      items: (filter, cs) => fetchParts(filter, cs),
      decoratorProps: const DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: "Select Part",
          border: OutlineInputBorder(),
        ),
      ),
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(isVisible: true),
      ),
      popupProps: PopupProps.dialog(
        infiniteScrollProps: InfiniteScrollProps(
          loadProps: LoadProps(skip: 0, take: 10),
        ),
        disableFilter: true,
        showSelectedItems: true,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: const InputDecoration(
            labelText: "Search Parts",
            border: OutlineInputBorder(),
          ),
        ),
        itemBuilder: (ctx, item, isDisabled, isSelected) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white, // White background
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300), // Row border
              ),
            ),
            child: ListTile(
              selected: isSelected,
              title: Text(item.partName),
              subtitle: Text("Qty Available: ${item.quantityAvailable}"),
            ),
          );
        },
      ),
      compareFn: (item, selectedItem) => item.partID == selectedItem.partID,
      selectedItem: selectedPart,
      itemAsString: (PartResponse? part) => part == null
          ? ''
          : "${part.partName} - Qty: ${part.quantityAvailable}",
      onChanged: onChanged,
      validator: validator,
    );
  }
}
