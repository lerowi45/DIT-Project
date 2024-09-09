import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final String label;
  final DateTime? initialDateTime;
  final void Function(DateTime) onDateTimeChanged;

  const DateTimePicker({
    Key? key,
    required this.label,
    this.initialDateTime,
    required this.onDateTimeChanged,
  }) : super(key: key);

  @override
  State<DateTimePicker> createState() => _CreateDateTimePickerState();
}

class _CreateDateTimePickerState extends State<DateTimePicker> {
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.initialDateTime ?? DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _dateTime = picked);
    widget.onDateTimeChanged(_dateTime);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (picked != null) {
      setState(() => _dateTime = DateTime(
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            picked.hour,
            picked.minute,
          ));
    }
    widget.onDateTimeChanged(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: widget.label),
            onTap: () => _selectDate(context),
            controller: TextEditingController(
                text:
                    '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}'),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Time (HH:mm:ss)'),
            onTap: () => _selectTime(context),
            controller: TextEditingController(
                text:
                    '${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}:${_dateTime.second.toString().padLeft(2, '0')}'),
          ),
        ),
      ],
    );
  }
}
