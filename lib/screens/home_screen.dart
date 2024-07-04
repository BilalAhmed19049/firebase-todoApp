import 'package:firebase_todoapp/utils/colors.dart';
import 'package:firebase_todoapp/utils/helpers.dart';
import 'package:firebase_todoapp/widgets/floatingbutton_widget.dart';
import 'package:firebase_todoapp/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_provider.dart';
import 'task_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: 'Tasks',
          color: CColors.white,
        ),
        backgroundColor: CColors.secondary,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.cloud_upload,
              color: Colors.white,
            ),
            onPressed: () async {
              // await ref.read(taskNotifierProvider.notifier).backupTasksToFirestore();
              tasks.isEmpty
                  ? Helpers.displaySnackBar(
                      context, 'No task available for backup')
                  : Helpers.showAlertDialog(context, ref);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.cloud_download,
              color: Colors.white,
            ),
            onPressed: () async {
              await ref
                  .read(taskNotifierProvider.notifier)
                  .fetchTasksFromFirestore()
                  .then((value) {
                Helpers.displaySnackBar(
                    context, 'Backup restored Successfully');
              });
            },
          ),
        ],
      ),
      backgroundColor: CColors.primary,
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks available',
                style: TextStyle(color: CColors.white),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(task.note),
                    subtitle: Text('${task.date} - ${task.time}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => TaskScreen(
                            task: task,
                            isChange: true,
                          ),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await ref
                            .read(taskNotifierProvider.notifier)
                            .deleteTask(task.id!);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => TaskScreen()),
          );
        },
        icon: Icon(
          Icons.add,
          color: CColors.secondary,
        ),
      ),
    );
  }
}
