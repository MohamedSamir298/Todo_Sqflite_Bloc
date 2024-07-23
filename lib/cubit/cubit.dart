import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_abdullah_mansour_course/cubit/states.dart';
import '../tabs/archived_tab.dart';
import '../tabs/done_tab.dart';
import '../tabs/tasks_tab.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  static AppCubit get(context) => BlocProvider.of(context);

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  int tabIndex = 0;
  List<Widget> tabs = [NewTasksTab(), DoneTasksTab(), ArchivedTasksTab()];
  List<String> titles = ["Tasks Tab", "Done Tab", "Archived Tab"];

  void changeIndex(int index) {
    tabIndex = index;
    emit(AppChangeStateBottomNavBar());
  }

  void createDatabase() async {
    database = await openDatabase("todo.db", version: 1,
        onCreate: (database, version) {
      print("database created");
      database
          .execute(
              'CREATE TABLE tasks  (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print("table created");
      }).catchError((error) {
        print("while creating table error : ${error.toString()}");
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);

      print("database opened");
    }).then((value) {
      emit(AppCreateDatabaseState());
      return database = value;
    });
  }

  insertToDatabase(
      {required String title, required String date, required String time}) {
    database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date", "$time", "new")')
          .then((value) {
        print("$value is inserted successfully");
        emit(AppInsertToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print(error.toString());
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetFromDatabaseLoadingState());
    database?.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if (element["status"] == "new") {
          newTasks.add(element);
        } else if (element["status"] == "done") {
          doneTasks.add(element);
        } else if (element["status"] == "archived") {
          archivedTasks.add(element);
        }
      });
      print("newtasks :   $newTasks");
      print("donetasks :   $doneTasks");
      print("archtasks :   $archivedTasks");
      emit(AppGetFromDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fab = Icons.edit;

  void changeBottomSheetState({required bool isShown, required IconData icon}) {
    isBottomSheetShown = isShown;
    fab = icon;

    emit(AppChangeBottomSheetState());
  }

  void updateStatus({required String status, required int id}) async {
    await database!
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status, id])
        .then((value) {
          getDataFromDatabase(database);
          emit(AppUpdateStatusOfDatabaseState());
        });
  }

  void deleteStatus({required int id}) async {
    await database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
          getDataFromDatabase(database);
          emit(AppDeleteStatusOfDatabaseState());
        });
  }
}
