import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (BuildContext context, state) {
        var tasks= AppCubit.get(context).archivedTasks;
        return tasksBuilder(
            tasks: tasks
        );
      },
      listener: (BuildContext context, Object? state) {  },
    );

  }
}
