import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app_abdullah_mansour_course/cubit/cubit.dart';
import 'package:todo_app_abdullah_mansour_course/cubit/states.dart';

class NewTasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List tasks = AppCubit.get(context).newTasks;
        return ConditionalBuilder(
            condition: tasks.isNotEmpty,
            builder: (context) => ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return buildTasksItem(
                      tasks[index]["time"],
                      tasks[index]["title"],
                      tasks[index]["date"],
                      tasks[index]["id"],
                      context);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 5,
                    thickness: 5,
                  );
                },
                itemCount: tasks.length),
            fallback: (context) => Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu,
                          size: 60,
                          color: Colors.grey,
                        ),
                        Text(
                          "No Tasks Yet, Add Some Tasks",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        )
                      ]),
                ));
      },
    );
  }

  Widget buildTasksItem(
      String time, String title, String date, int id, context) {
    return Slidable(
      key: Key("$id"),
      startActionPane: ActionPane(
        dismissible: DismissiblePane(onDismissed: () {
          AppCubit.get(context).deleteStatus(id: id);
        }),
        // A motion is a widget used to control how the pane animates.
        motion: const BehindMotion(),
        // All actions are defined in the children parameter.
        children: [
          // A Slidable Action can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) {
              AppCubit.get(context).deleteStatus(id: id);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              AppCubit.get(context).updateStatus(status: "done", id: id);
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.done_outline_rounded,
            label: 'Done',
          ),
          SlidableAction(
            onPressed: (context) {
              AppCubit.get(context).updateStatus(status: "archived", id: id);
            },
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              child: Text(
                time,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    date,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
