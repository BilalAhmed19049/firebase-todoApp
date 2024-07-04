import 'package:firebase_todoapp/models/taskmodel.dart';
import 'package:firebase_todoapp/providers/date_provider.dart';
import 'package:firebase_todoapp/providers/time_provider.dart';
import 'package:firebase_todoapp/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../providers/task_provider.dart';
import '../utils/colors.dart';
import '../widgets/floatingbutton_widget.dart';
import '../widgets/select_date_time.dart';
import '../widgets/text_widget.dart';
import '../widgets/textfield_widget.dart';

class TaskScreen extends ConsumerWidget {
  final Taskmodel? task;
  final bool? isChange;

  TaskScreen({
    super.key,
    this.task,
    this.isChange,
  });

  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final time = ref.watch(timeProvider);

    if (task != null) {
      _taskController.text = task!.note;
    }

    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: task == null ? 'New Task' : 'Edit Task',
          color: CColors.white,
        ),
        backgroundColor: CColors.secondary,
      ),
      backgroundColor: CColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: 'What is to be done?',
              color: CColors.white,
              fontWeight: FontWeight.w600,
            ),
            TextFieldWidget(
              controller: _taskController,
              hintText: 'Pay bills',
            ),
            const Gap(30),
            TextWidget(
              text: 'Due Date',
              color: CColors.white,
              fontWeight: FontWeight.w600,
            ),
            const SelectDateTime(),
          ],
        ),
      ),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () async {
          final newTask = Taskmodel(
            id: task?.id ?? Uuid().v4(), // Ensure a unique ID for new tasks
            time: Helpers.timeToString(time),
            date: DateFormat.yMMMd().format(date),
            note: _taskController.text,
            // title: _taskController.text,
          );
          if (task == null) {
            await ref
                .read(taskNotifierProvider.notifier)
                .addTask(newTask)
                .then((value) {
              Helpers.displaySnackBar(context, 'Task Created ');
            });
          } else {
            await ref
                .read(taskNotifierProvider.notifier)
                .updateTask(newTask)
                .then((value) {
              Helpers.displaySnackBar(context, 'Task Updated');
            });
          }

          _taskController.clear();

          Navigator.pop(context);
        },
        icon: const Icon(Icons.check),
      ),
    );
  }
}
