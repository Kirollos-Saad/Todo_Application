import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_application/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit(): super (AppInitialState());
  
  static AppCubit get(context)=> BlocProvider.of(context);
  int currentIndex=0;
  List <Widget> screens= [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),

  ];
  List <String> titles=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
 void changeIndex(int index)
 {
   currentIndex=index;
   emit(AppChangeBottomNavBarState());
 }
  Database ?database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
  void createDatabase()  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async {
        print('database created');
        await db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
        print('table created');
      },
      onOpen: (db) {
        database = db; // Assign the opened database reference to the class-level variable
        print('database opened');
      },
    ).then((value)
     {
       database=value;
       emit(AppCreateDataBaseState());
     });
  }


   insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await database?.transaction((txn) async
    {
      await txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted succesfully');
        emit(AppInsertDataBaseState());
        getDataFromDatabase(database);

      }).catchError((error){
        print('Error when inserting new recrod ${error.toString()}');
      });

    }
    );
  }
  void getDataFromDatabase(database) {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
      emit(AppGetDataBaseLoadingState());
       database.rawQuery('SELECT * FROM tasks').then((value){
         value.forEach((element)
         {
           if(element['status']=='new')
             newTasks.add(element);
           else if(element['status']=='done')
             doneTasks.add(element);
           else archivedTasks.add(element);

         });
         emit(AppGetDataBaseState());
       });

  }

  void updateData({
    required String status,
    required int id
}) async
  {   database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
  ).then((value) {
    getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
  });

  }

  void deleteData({
    required int id
  }) async
  {   database!.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id]

  ).then((value) {
    getDataFromDatabase(database);
    emit(AppDeleteDataBaseState());
  });

  }
  bool isBottomSheetShown= false;
  IconData fabIcon=Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown= isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }
}