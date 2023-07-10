import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_application/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_application/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_application/modules/new_tasks/new_tasks_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:todo_application/shared/cubit/cubit.dart';
import 'package:todo_application/shared/cubit/states.dart';

import '../shared/components/constants.dart';



class HomeLayout extends StatelessWidget
{


  var scaffoldkey=GlobalKey<ScaffoldState>();
  var formkey=GlobalKey<FormState>();
  var titleController= TextEditingController();
  var timeController= TextEditingController();
  var dateController= TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: state is AppGetDataBaseLoadingState?Center(child: CircularProgressIndicator()): cubit.screens[cubit.currentIndex] ,
            floatingActionButton: FloatingActionButton(
              onPressed: ()
              { if(cubit.isBottomSheetShown)
              {
                if(formkey.currentState!.validate())
                { cubit.insertDatabase(
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text);
                //   insertDatabase(
                //   title: titleController.text ,
                //   date: dateController.text ,
                //   time: timeController.text,
                // )?.then((value) {
                //   getDataFromDatabase(database).then((value)
                //   { Navigator.pop(context);
                //     // setState(() {
                //     //   isBottomSheetShown=false;
                //     //   fabIcon=Icons.edit;
                //     //   tasks=value;
                //     // });
                //   });
                //
                // });
                }
               // cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                // Clear the form fields
                titleController.clear();
                timeController.clear();
                dateController.clear();
              }

              else
              {  scaffoldkey.currentState?.showBottomSheet(
                    (context) =>
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.text,
                              decoration:
                              InputDecoration(
                                labelText: 'Task Title',
                                border: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(5.0),
                                ),
                                prefixIcon:Icon(
                                  Icons.title,
                                ) ,
                              ),
                              controller: titleController,
                              validator:(value){
                                if(value!.isEmpty)
                                {
                                  return 'title must not be empty';
                                }
                                return null;
                              },

                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              decoration:
                              InputDecoration(
                                labelText: 'Task Time',
                                border: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(5.0),
                                ),
                                prefixIcon:Icon(
                                  Icons.watch_later_outlined,
                                ) ,
                              ),
                              controller: timeController,
                              onTap: (){
                                showTimePicker(context: context,
                                    initialTime: TimeOfDay.now()).then((value)
                                {
                                  timeController.text=value!.format(context).toString();
                                });
                              },
                              validator:(value){
                                if(value!.isEmpty)
                                {
                                  return 'time must not be empty';
                                }
                                return null;
                              },

                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              decoration:
                              InputDecoration(
                                labelText: 'Task Date',
                                border: OutlineInputBorder(
                                  borderRadius:BorderRadius.circular(5.0),
                                ),
                                prefixIcon:Icon(
                                  Icons.calendar_today,
                                ) ,
                              ),
                              controller: dateController,
                              onTap: (){
                                showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2030-12-30'),
                                ).then((value) {
                                  dateController.text=DateFormat.yMMMd().format(value!);
                                });
                              },
                              validator:(value){
                                if(value!.isEmpty)
                                {
                                  return 'Date must not be empty';
                                }
                                return null;
                              },

                            )
                          ],
                        ),
                      ),
                    ),
                elevation: 20.0,
              ).closed.then((value)
              { cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);

              });
              cubit.changeBottomSheetState(isShow: true, icon:  Icons.add);
              }

              },
              child: Icon(
                  cubit.fabIcon
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type:BottomNavigationBarType.fixed ,
              currentIndex:cubit.currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
              },
              items:
              const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline_outlined,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ) ,
          );
        },
        listener: (BuildContext context, Object? state) {
          if(state is AppInsertDataBaseState )
            {Navigator.pop(context);}
        },

      ),
    );
  }


}


