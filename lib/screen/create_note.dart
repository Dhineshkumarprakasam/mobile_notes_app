import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_notes_app/database_connection/connection.dart';

class CreateNote extends StatefulWidget {
  String type_exist;
  int? id_exist;
  String? title_exist;
  String? content_exist;
  CreateNote({
    this.type_exist = "Create",
    this.id_exist,
    this.title_exist,
    this.content_exist,
    super.key,
  });

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late String dateTime;

  int characters = 0;
  void changeCount(int c) {
    setState(() {
      characters = c;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.type_exist == "Update") {
      titleController.text = widget.title_exist!;
      contentController.text = widget.content_exist!;
      changeCount(widget.content_exist!.length);
    }
  }

  void update() {
    DatabaseConnection con = DatabaseConnection();
    con.updateData(
      widget.id_exist!,
      titleController.text,
      contentController.text,
      dateTime,
    );
  }

  void SaveData() {
    String title = titleController.text;
    String content = contentController.text;
    DatabaseConnection con = DatabaseConnection();
    if (content.isNotEmpty || title.isNotEmpty) {
      if (content.isEmpty)
        con.insertData(title, "No Content", dateTime);
      else if (title.isEmpty)
        con.insertData("No Title", content, dateTime);
      else
        con.insertData(title, content, dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String day = DateFormat('EEEE').format(now);
    String month = DateFormat('MMMM').format(now);
    String date = DateFormat('dd').format(now);
    String time = DateFormat('hh:mm a').format(now);
    dateTime = "$day, $month $date at $time";
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop)
          print("poped");
        else {
          showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text("Save Changes"),
              content: Container(
                padding: EdgeInsets.only(top: 20),
                child: Text("Do you want to save the changes?"),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (widget.type_exist == "Update")
                      update();
                    else
                      SaveData();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("yes"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("no"),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "${widget.type_exist} Note",
            style: GoogleFonts.acme(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),

        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: GoogleFonts.roboto(
                        fontSize: 24,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      filled: false,
                      border: InputBorder.none,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateTime,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),

                        Text(
                          "Characters: $characters",
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //content body
              Container(
                margin: EdgeInsets.only(top: 20),
                child: TextField(
                  onChanged: (value) {
                    changeCount(value.length);
                  },
                  controller: contentController,

                  decoration: InputDecoration(
                    fillColor: Colors.grey[100],
                    hintText: "Content",
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 18,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: MediaQuery.of(context).viewInsets.bottom > 0
                      ? 7
                      : 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
