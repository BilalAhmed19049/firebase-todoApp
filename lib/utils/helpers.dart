import 'package:firebase_todoapp/providers/task_provider.dart';
import 'package:firebase_todoapp/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/date_provider.dart';
import '../providers/time_provider.dart';
import 'colors.dart';

class Helpers {
  static String timeToString(TimeOfDay time) {
    try {
      final DateTime now = DateTime.now();
      final date =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);

      return DateFormat.jm().format(date);
    } catch (e) {
      return '12:00 p.m';
    }
  }

  static void selectTime(BuildContext context, WidgetRef ref) async {
    final initialTime = ref.read(timeProvider);
    TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: initialTime);

    if (pickedTime != null) {
      ref.read(timeProvider.notifier).state = pickedTime;
    }
  }

  static void selectDate(BuildContext context, WidgetRef ref) async {
    final initialDate = ref.read(dateProvider);
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      ref.read(dateProvider.notifier).state = pickedDate;
    }
  }

  static displaySnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: CColors.primary,
      content: Text(message, style: TextStyle(color: CColors.white)),
    ));
  }

  static Future<void> showAlertDialog(
      BuildContext context, WidgetRef ref) async {
    Widget cancelButton = TextButton(
        onPressed: () => Navigator.pop(context),
        child: TextWidget(text: 'No', color: Colors.red));

    Widget confirmButton = TextButton(
        onPressed: () async {
          await ref
              .read(taskNotifierProvider.notifier)
              .backupTasksToFirestore()
              .then((value) {
            displaySnackBar(context, 'Backup Created Successfully');
            Navigator.pop(context);
          });
        },
        child: TextWidget(text: 'Yes', color: Colors.blue));

    AlertDialog alert = AlertDialog(
      title: TextWidget(
        text: 'Are you sure, to create backup of your notes?',
        color: Colors.black,
        size: 16,
      ),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );
    await showDialog(context: context, builder: (ctx) => alert);
  }
}
