import 'package:fetch_get/app_database.dart';
import 'package:fetch_get/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController Title = TextEditingController();
  TextEditingController Desc = TextEditingController();

  late DbHelper db;
  List<Notes_Model> arrNotes = [];

  @override
  void initState() {
    super.initState();
    db = DbHelper.db;
    getAllNotes();
  }

  void getAllNotes() async {
    arrNotes = await db.fetchAllData();
    setState(() {});
  }

  void addNotes(String title, String desc) async {
    await db.addNotes(Notes_Model(title: title, desc: desc));
    arrNotes = await db.fetchAllData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Notes',
            style: TextStyle(
                fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          )
        ],
      ),

      // child: GridView.custom(
      //   gridDelegate: SliverStairedGridDelegate(
      //     crossAxisSpacing: 10,
      //     mainAxisSpacing: 10,
      //     startCrossAxisDirectionReversed: false,
      //     pattern: [
      //       StairedGridTile(1.0, 10 / 5),
      //       StairedGridTile(1.0, 10 / 5),
      //       StairedGridTile(1.0, 10 / 5),
      //     ],

      // childrenDelegate: SliverChildBuilderDelegate(
      //     childCount: arrNotes.length,
      //     (context, index) =>
      body: ListView.builder(
          itemCount: arrNotes.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                TextEditingController UpdateTitle =
                    TextEditingController(text: arrNotes[index].title);
                TextEditingController UpdateDesc =
                    TextEditingController(text: arrNotes[index].desc);
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 50,
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextField(
                                  controller: UpdateTitle,
                                  decoration: InputDecoration(
                                      hintText: 'Enter your Title',
                                      prefixIcon: Icon(Icons.person),
                                      border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      filled: true,
                                      fillColor: Colors.orange),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: UpdateDesc,
                                  decoration: InputDecoration(
                                      hintText: 'Enter Desc',
                                      prefixIcon: Icon(Icons.lock),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      filled: true,
                                      fillColor: Colors.orange),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    db.updateNotes(Notes_Model(
                                        id: arrNotes[index].id,
                                        title: UpdateTitle.text,
                                        desc: UpdateDesc.text));
                                    getAllNotes();
                                    Navigator.pop(context);

                                  },
                                  child: Text(
                                    'Update',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(250, 50),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Card(
                child: Container(
                  width: double.infinity,
                  color: Colors.primaries[index],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: Text(index.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),
                      SizedBox(
                        width: 26,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(arrNotes[index].title,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(arrNotes[index].desc,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 47,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: IconButton(
                              onPressed: () {
                                db.deleteNotes(arrNotes[index].id!);
                                getAllNotes();
                              },
                              icon: Icon(Icons.delete)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: Title,
                        decoration: InputDecoration(
                            hintText: 'Enter your Title',
                            prefixIcon: Icon(Icons.person),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            filled: true,
                            fillColor: Colors.orange),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: Desc,
                        decoration: InputDecoration(
                            hintText: 'Enter Desc',
                            prefixIcon: Icon(Icons.lock),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            fillColor: Colors.orange),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addNotes(Title.text, Desc.text);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(fontSize: 25),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(250, 50),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
