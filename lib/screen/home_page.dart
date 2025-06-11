import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_notes_app/database_connection/model.dart';

import '../database_connection/connection.dart';
import 'create_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dataModel> notes;

  void readAll() async {
    DatabaseConnection con = DatabaseConnection();
    var out = await con.readAll();
    print(out); // out is List<Map<String, dynamic>>
    setState(() {
      notes = out.map<dataModel>((e) {
        return dataModel(e['id'], e['title'], e['content'], e['time']);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    notes = [];
    readAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        centerTitle: true,
        title: Text(
          "Notes",
          style: GoogleFonts.acme(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateNote()))
              .then((value) {
                readAll();
              });
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.redAccent,
      ),

      body: notes.isEmpty
          ? Container(
              child: Center(
                child: Text(
                  "No Notes Found",
                  style: GoogleFonts.acme(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            )
          : Container(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text("Confirm Delete"),
                          content: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Do you want to delete '${notes[index].title}'?",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              }, // Cancel
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              }, // Confirm
                              child: Text("Yes"),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      DatabaseConnection con = DatabaseConnection();
                      con.deleteData(notes[index].id!);
                      setState(() {
                        notes.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Note Deleted",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        readAll();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.redAccent.shade200,
                            width: 5,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[100],
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => CreateNote(
                                    type_exist: "Update",
                                    id_exist: notes[index].id,
                                    title_exist: notes[index].title,
                                    content_exist: notes[index].content,
                                  ),
                                ),
                              )
                              .then((value) {
                                readAll();
                              });
                        },
                        title: Text(
                          notes[index].title!.capitalize!,
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notes[index].content!.length < 50
                                  ? notes[index].content!.capitalize.replaceAll(
                                      "\n",
                                      " ",
                                    )
                                  : notes[index].content!
                                            .substring(0, 25)
                                            .capitalize
                                            .replaceAll("\n", " ") +
                                        " .....",
                              style: GoogleFonts.roboto(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              notes[index].time!,
                              style: GoogleFonts.roboto(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
