import 'package:flutter/material.dart';
import 'package:todo_application/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 35.0,
  
          child: Text(
  
            '${model['time']}',
  
          ),
  
        ),
  
        SizedBox(
  
          width: 20.0,
  
        ),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
              Text(
  
                '${model['title']}',
  
                style: TextStyle(
  
                  fontSize: 18.0,
  
                  fontWeight: FontWeight.bold,
  
                ),
  
              ),
  
              Text(
  
                '${model['date']}',
  
                style: TextStyle(
  
                  color: Colors.grey,
  
                ),
  
              ),
  
            ],
  
          ),
  
        ),
  
        SizedBox(
  
          width: 20.0,
  
        ),
  
        IconButton(
  
            onPressed:() {
  
               AppCubit.get(context).updateData(status: 'done', id: model['id']);
  
            },
  
            icon: Icon(
  
              Icons.check_box,
  
              color: Colors.green,
  
            ),
  
        ),
  
        IconButton(
  
          onPressed:() {
  
            AppCubit.get(context).updateData(status: 'archive', id: model['id']);
  
          },
  
          icon: Icon(
  
              Icons.archive,
  
            color: Colors.black45,
  
          ),
  
        ),
  
      ],
  
    ),
  
  ),
  onDismissed:(direction){
   AppCubit.get(context).deleteData(id:model['id'] );
  } ,
);

Widget tasksBuilder({
  required List<Map> tasks
}) {
  if (tasks.length > 0) {
    return ListView.separated(
      itemBuilder: (context, index) =>
          buildTaskItem(
              tasks[index], context
          ),
      separatorBuilder: (context, index) =>
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 20.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
      itemCount: tasks.length,
    );
  }
  else {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,

            ),
          ),
        ],
      ),
    );
  }
}
