
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/model/todo_model.dart';
import 'package:todo_list/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var taskController = TextEditingController();
  IconData taskIcon = Icons.done;

  initializeApp()
  {
    Firebase.initializeApp().whenComplete(() {
    });

  }

  @override
  void initState() {
    super.initState();
    initializeApp();
  }
  void _addTask()
  {
    if(taskController.text != '') {
      FirebaseFirestore.instance.collection("todos").add(
        {
          "title" : taskController.text.trim(),
          "status": false
        }
      );
      taskController.text = "";
    }

  }

  @override
  Widget build(BuildContext context) {
    //initializeApp();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Todo List', style: TextStyle(color: Colors.blue),),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Column(
          children:  <Widget>[
            Row(
              children: [
                 InputFeild(
                  controller: taskController,
                  hintText: 'Enter Task Here',
                  icon: const Icon(Icons.task)
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                      onPressed: _addTask,
                      icon: const Icon(Icons.add_task, color: Colors.white, size: 25,),
                      splashRadius: 22,
                  ),
                )
              ],
            ),
            StreamBuilder<QuerySnapshot?>(
              stream: FirebaseFirestore.instance.collection("todos").snapshots(),
              builder: (context, snapshot)
              {
                if (snapshot.hasData)
                  {
                    return Expanded(
                        child: taskList(snapshot.data)
                    );
                  }
                // else if (snapshot.connectionState == ConnectionState.none)
                //   {
                //     return const Center(child: Text('No Data'),);
                //   }
                  else
                    {
                      return  Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
              },
            )
          ],
        ),
      ),
    );
  }

  taskList(QuerySnapshot<Object?>? data) {

    return GestureDetector(
      dragStartBehavior: DragStartBehavior.start,
      onVerticalDragDown: (DragDownDetails details){
        setState(() {
          details.localPosition.direction;
        });
      },
      child: ListView.builder(
        itemCount: data!.docs.length,
          itemBuilder: (context, index)
        {
          final doc = data.docs[index];
          final task = Task.fromSnapshot(doc);
          IconData cardIcon = Icons.check_circle_outline;
          if(task.status) {
            cardIcon = Icons.check_circle;
          } else {
            cardIcon = Icons.check_circle_outline;
          }
          return TaskCard(
              title: task.title,
              leading: IconButton(
                onPressed: ()
                {

                  setState(() {
                    if(task.status) {
                      _updateTask(task, false);
                      cardIcon = Icons.check_circle;
                    } else {
                      _updateTask(task, true);
                      cardIcon = Icons.check_circle_outline;
                    }
                  });
                },
                icon: Icon(cardIcon, size: 30, color: Colors.blue,),
                splashRadius: 15,
              ),
            trailing: IconButton(
              onPressed: ()
              {
                _deleteTask(task);
              },
              icon: const Icon(Icons.delete, size: 30, color: Colors.red),
              splashRadius: 20,
            ),

          );
        },
      ),
    );
  }

   _deleteTask(Task task) async
   {
     await FirebaseFirestore.instance.collection('todos').doc(task.taskId).delete();
   }
  _updateTask(Task task, bool status) async
  {
    await FirebaseFirestore.instance.collection('todos').doc(task.taskId).update(
      {
        "status": status
      }
    );
  }
}
