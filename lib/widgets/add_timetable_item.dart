import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTimetableItem extends StatefulWidget {
  final FutureOr<void> Function(String subject, DateTime time) addTimetableItem;

  const AddTimetableItem({super.key, required this.addTimetableItem});

  @override
  State<AddTimetableItem> createState() => _AddTimetableItemState();
}

class _AddTimetableItemState extends State<AddTimetableItem> {
  final _subjectController = TextEditingController();
  DateTime dateTime = DateTime.now();

  void _submitData() {
    if (_subjectController.text.isEmpty) return;
    widget.addTimetableItem(_subjectController.text, dateTime);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Exam"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(labelText: "Subject"),
            onSubmitted: (_) {},
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final date = await pickDate();
                    if (date == null) return;
                    final time = await pickTime();
                    if (time == null) return;

                    final dateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                    setState(() => this.dateTime = dateTime);
                  },
                  child:
                      Text(DateFormat("yyyy-MM-dd – kk:mm").format(dateTime)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submitData,
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );
}
