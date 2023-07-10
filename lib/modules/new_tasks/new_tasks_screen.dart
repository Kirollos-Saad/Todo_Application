import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application/shared/components/components.dart';
import 'package:todo_application/shared/cubit/cubit.dart';
import 'package:todo_application/shared/cubit/states.dart';

import '../../shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state) {
        var tasks= AppCubit.get(context).newTasks;
       return tasksBuilder(
         tasks: tasks
       );
      },

    );
  }
}
