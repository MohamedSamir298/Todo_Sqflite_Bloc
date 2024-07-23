import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_abdullah_mansour_course/cubit/cubit.dart';
import 'package:todo_app_abdullah_mansour_course/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var selectedDate;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(state is AppInsertToDatabaseState){
            Navigator.pop(context);
            titleController.clear();
            timeController.clear();
            dateController.clear();
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(
                  cubit.titles[cubit.tabIndex],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  print("working");
                  if (cubit.isBottomSheetShown) {
                    if(formKey.currentState!.validate()){
                      cubit.insertToDatabase(
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text);
                      cubit.changeBottomSheetState(
                          isShown: false, icon: Icons.edit);
                      // cubit.isBottomSheetShown = false;
                      // cubit.fab = Icons.edit;
                    }
                  } else if (cubit.isBottomSheetShown == false) {
                    scaffoldKey.currentState?.showBottomSheet((context) => Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: titleController,
                                  validator: (value) {
                                    if (value == "") {
                                      return "title can't be empty!";
                                    }
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.title),
                                      labelText: "Title",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2029-01-01'))
                                        .then((value) {
                                      print(DateFormat.yMMMd().format(value!));
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  controller: dateController,
                                  validator: (value) {
                                    if (value == "") {
                                      return "date can't be empty!";
                                    }
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.date_range),
                                      labelText: "Date",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context);
                                    });
                                  },
                                  controller: timeController,
                                  validator: (value) {
                                    if (value == "") {
                                      return "time can't be empty!";
                                    }
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.access_time),
                                      labelText: "Time",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                            ],
                          ),
                        ));
                    cubit.changeBottomSheetState(
                        isShown: true, icon: Icons.add);
                    // cubit.fab = Icons.add;
                    // cubit.isBottomSheetShown = true;
                  }
                  // insertToDatabase();
                },
                child: Icon(cubit.fab),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.black,
                currentIndex: cubit.tabIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done_outline_rounded), label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: "Archived"),
                ],
              ),
              body: state is! AppGetFromDatabaseLoadingState ? cubit.tabs[cubit.tabIndex] : Center(child: CircularProgressIndicator()) ,


            //cubit.tabs[cubit.tabIndex]
              // cubit.tasks.length == 0
              //     ? Center(child: CircularProgressIndicator())
              //     : cubit.tabs[cubit.tabIndex],
              );
        },
      ),
    );
  }
}
