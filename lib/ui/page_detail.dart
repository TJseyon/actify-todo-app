import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:actify/model/element.dart';

class DetailPage extends StatefulWidget {
  final User? user;
  final int i;
  final Map<String, List<ElementTask>> currentList;
  final String color;

  const DetailPage({
    Key? key,
    required this.user,
    required this.i,
    required this.currentList,
    required this.color,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String get listName => widget.currentList.keys.elementAt(widget.i);

  Future<void> _toggleTask(String taskName, bool currentValue) async {
    if (widget.user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection(widget.user!.uid)
          .doc(listName)
          .update({taskName: !currentValue});
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse(widget.color)),
        elevation: 0,
        title: Text(listName),
      ),
      body: Container(
        color: Color(int.parse(widget.color)),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection(widget.user?.uid ?? 'offline')
              .doc(listName)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            List<ElementTask> tasks = [];

            data.forEach((key, value) {
              if (value is bool) {
                tasks.add(ElementTask(key, value));
              }
            });

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                final task = tasks[index];
                return ListTile(
                  onTap: () => _toggleTask(task.name, task.isDone),
                  leading: Icon(
                    task.isDone
                        ? FontAwesomeIcons.circleCheck
                        : FontAwesomeIcons.circle,
                    color: Colors.white,
                  ),
                  title: Text(
                    task.name,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DonePage extends StatefulWidget {
  final User? user;

  const DonePage({Key? key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _getToolbar(context),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            'Task',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 175.0),
            child: Container(
              height: 360.0,
              padding: const EdgeInsets.only(bottom: 25.0),
              child: widget.user == null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_off, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Offline Mode',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              )
                  : NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(widget.user!.uid)
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding:
                      const EdgeInsets.only(left: 40.0, right: 40.0),
                      scrollDirection: Axis.horizontal,
                      children: getExpenseItems(snapshot),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ElementTask> listElement = [];
    List<ElementTask> listElement2;
    Map<String, List<ElementTask>> userMap = {};

    List<String> cardColor = [];
    if (widget.user?.uid.isNotEmpty ?? false) {
      cardColor.clear();

      snapshot.data!.docs.map<List>((f) {
        (f.data() as Map<String, dynamic>).forEach((a, b) {
          if (b.runtimeType == bool) {
            listElement.add(ElementTask(a, b));
          }
          if (b.runtimeType == String && a == "color") {
            cardColor.add(b);
          }
        });
        listElement2 = List<ElementTask>.from(listElement);
        userMap[f.id] = listElement2;

        for (int i = 0; i < listElement2.length; i++) {
          if (listElement2.elementAt(i).isDone == false) {
            userMap.remove(f.id);
            if (cardColor.isNotEmpty) {
              cardColor.removeLast();
            }
            break;
          }
        }
        if (listElement2.isEmpty) {
          userMap.remove(f.id);
          if (cardColor.isNotEmpty) {
            cardColor.removeLast();
          }
        }
        listElement.clear();
        return [];
      }).toList();

      return List.generate(userMap.length, (int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => DetailPage(
                  user: widget.user,
                  i: index,
                  currentList: userMap,
                  color: cardColor.elementAt(index),
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(
                      scale: Tween<double>(
                        begin: 1.5,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: const Interval(
                            0.50,
                            1.00,
                            curve: Curves.linear,
                          ),
                        ),
                      ),
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: const Interval(
                              0.00,
                              0.50,
                              curve: Curves.linear,
                            ),
                          ),
                        ),
                        child: child,
                      ),
                    ),
              ),
            );
          },
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            color: Color(int.parse(cardColor.elementAt(index))),
            child: Container(
              width: 220.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                    child: Text(
                      userMap.keys.elementAt(index),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.only(left: 50.0),
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 15.0, right: 5.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 220.0,
                          child: ListView.builder(
                            itemCount: userMap.values.elementAt(index).length,
                            itemBuilder: (BuildContext ctxt, int i) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    userMap.values
                                        .elementAt(index)
                                        .elementAt(i)
                                        .isDone
                                        ? FontAwesomeIcons.circleCheck
                                        : FontAwesomeIcons.circle,
                                    color: userMap.values
                                        .elementAt(index)
                                        .elementAt(i)
                                        .isDone
                                        ? Colors.white70
                                        : Colors.white,
                                    size: 14.0,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                  ),
                                  Flexible(
                                    child: Text(
                                      userMap.values
                                          .elementAt(index)
                                          .elementAt(i)
                                          .name,
                                      style: userMap.values
                                          .elementAt(index)
                                          .elementAt(i)
                                          .isDone
                                          ? const TextStyle(
                                        decoration:
                                        TextDecoration.lineThrough,
                                        color: Colors.white70,
                                        fontSize: 17.0,
                                      )
                                          : const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }
    return [];
  }

  Padding _getToolbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            width: 40.0,
            height: 40.0,
            fit: BoxFit.cover,
            image: AssetImage('assets/list.png'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}