import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maintboard/search_provider.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  final String hintText;
  final VoidCallback onClose;

  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.onClose,
  });

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  Timer? _debounce;

  void _onSearchChanged(String value) {
    // Cancel the previous timer if the user is still typing
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () {
      // Update search query only after 1000ms delay
      debugPrint("Search Query: $value"); // Debugging log
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cleanup timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: _onSearchChanged, // Debounced search
            autofocus: true,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            textCapitalization: TextCapitalization
                .sentences, // Capitalizes first letter of each sentence
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
