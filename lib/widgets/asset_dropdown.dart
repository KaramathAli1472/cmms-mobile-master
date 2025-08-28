// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:maintboard/core/models/asset/asset_response.dart';
import 'package:maintboard/core/services/asset_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';

class AssetDropdown extends StatelessWidget {
  final ValueChanged<AssetResponse?> onChanged;
  final AssetResponse? selectedAsset;
  final String? Function(AssetResponse?)? validator;

  const AssetDropdown({
    super.key,
    required this.onChanged,
    this.selectedAsset,
    this.validator,
  });

  Future<List<AssetResponse>> fetchAssets(
      String? filter, LoadProps? loadProps) async {
    final int skip = loadProps?.skip ?? 0;
    final int take = loadProps?.take ?? 20;

    try {
      final int? siteID = await SharedPreferenceService.getCurrentSiteID();
      return await AssetService().fetchAssetList(
        queryParams: {
          'siteID': siteID,
          'searchTerm': filter,
          'rowsPerPage': take,
          'pageNumber': skip ~/ take,
          'sort': 'AssetName_ASC',
        },
      );
    } catch (e) {
      SnackbarService.showError(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<AssetResponse>(
      items: (filter, cs) => fetchAssets(filter, cs),
      decoratorProps: const DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: "Select Asset",
          border: OutlineInputBorder(),
        ),
      ),
      suffixProps: DropdownSuffixProps(
          clearButtonProps: ClearButtonProps(isVisible: true)),
      popupProps: PopupProps.dialog(
          infiniteScrollProps: InfiniteScrollProps(
            loadProps: LoadProps(skip: 0, take: 10),
          ),
          disableFilter: true,
          showSelectedItems: true,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: const InputDecoration(
              labelText: "Search Assets",
              border: OutlineInputBorder(),
            ),
          ),
          itemBuilder: (ctx, item, isDisabled, isSelected) {
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  border: Border(
                    bottom:
                        BorderSide(color: Colors.grey.shade300), // Row border
                  ),
                ),
                child: ListTile(
                    selected: isSelected,
                    title: Text(item.assetName),
                    subtitle: Text(item.fullLocationPathDisplay)));
          }),
      compareFn: (item, selectedItem) => item.assetID == selectedItem.assetID,
      selectedItem: selectedAsset,
      itemAsString: (AssetResponse? asset) => asset == null
          ? ''
          : "${asset.assetName}\n${asset.fullLocationPathDisplay}",
      onChanged: onChanged,
      validator: validator,
    );
  }
}
