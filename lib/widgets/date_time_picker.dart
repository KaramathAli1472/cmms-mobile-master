import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final ValueChanged<DateTime?> onChanged;
  final String label;
  final String? Function(DateTime?)? validator;

  const DateTimePicker({
    super.key,
    required this.initialDateTime,
    required this.onChanged,
    this.label = 'Select Date and Time',
    this.validator,
  });

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  Future<void> _pickDateTime(
      BuildContext context, FormFieldState<DateTime?> field) async {
    // Show Date Picker
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      // Show Time Picker
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _selectedDateTime ?? DateTime.now(),
        ),
      );

      if (time != null) {
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        setState(() {
          _selectedDateTime = newDateTime;
        });
        widget.onChanged(newDateTime);
        field.didChange(newDateTime); // Notify FormField of the change
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime?>(
      validator: widget.validator,
      builder: (field) {
        return GestureDetector(
          onTap: () => _pickDateTime(context, field),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
              errorText: field.errorText, // Show validation error
            ),
            child: Text(
              _selectedDateTime == null
                  ? 'Select Date & Time'
                  : '${_selectedDateTime!.toLocal()}'.split('.')[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _selectedDateTime == null
                    ? Theme.of(context).hintColor
                    : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
