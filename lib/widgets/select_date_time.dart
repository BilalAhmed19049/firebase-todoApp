import 'package:firebase_todoapp/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../providers/date_provider.dart';
import '../providers/time_provider.dart';
import '../utils/helpers.dart';

class SelectDateTime extends ConsumerWidget {
  const SelectDateTime({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final time = ref.watch(timeProvider);
    return Column(
      children: [
        TextFieldWidget(
          readOnly: true,
          //title: 'Date',
          hintText: DateFormat.yMMMd().format(date),
          suffixIcon: IconButton(
            onPressed: () {
              Helpers.selectDate(context, ref);
            },
            icon: Icon(Icons.calendar_month),
          ),
        ),
        const Gap(10),
        TextFieldWidget(
          readOnly: true,
          // title: 'Time',
          hintText: Helpers.timeToString(time),
          suffixIcon: IconButton(
            onPressed: () {
              Helpers.selectTime(context, ref);
            },
            icon: Icon(Icons.access_time_outlined),
          ),
        ),
      ],
    );
  }
}
