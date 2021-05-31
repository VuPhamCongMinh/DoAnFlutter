import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class TodoFormWidget extends StatelessWidget {
  final String title;
  final DateTime deadlineDate;
  final String description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<DateTime> onDatePickerSelect;
  final VoidCallback onSavedTodo;

  const TodoFormWidget({
    Key key,
    this.title = '',
    this.description = '',
    this.deadlineDate,
    @required this.onChangedTitle,
    @required this.onDatePickerSelect,
    @required this.onChangedDescription,
    @required this.onSavedTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            SizedBox(height: 6),
            buildDescription(),
            buildDatePicker(context),
            buildButton(),
            if (deadlineDate != null)
              Text(
                'Deadline : ${DateFormat('dd-MM | hh:mm a').format(deadlineDate)}',
              )
          ],
        ),
      );

  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 15),
        maxLines: 1,
        initialValue: title,
        onChanged: onChangedTitle,
        validator: (title) {
          if (title.isEmpty) {
            return 'The title cannot be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Title',
        ),
      );

  Widget buildDescription() => TextFormField(
        style: TextStyle(fontSize: 15),
        maxLines: 2,
        initialValue: description,
        onChanged: onChangedDescription,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Description',
        ),
      );

  Widget buildDatePicker(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
          ),
          onPressed: () {
            DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: deadlineDate ?? DateTime.now(),
                    maxTime: DateTime(2074, 06, 20),
                    currentTime: DateTime.now(),
                    locale: LocaleType.en)
                .then(onDatePickerSelect);
          },
          child: Text('Choose deadline'),
        ),
      );
  Widget buildButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
          ),
          onPressed: onSavedTodo,
          child: Text('Save'),
        ),
      );
}
