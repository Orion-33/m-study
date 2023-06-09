import 'dart:ffi';

import 'package:book_club/models/book.dart';
import 'package:book_club/models/user.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/services/database.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OurAddBook extends StatefulWidget {
  final bool onGroupCreation;
  final String groupName;
  final String name;
  final String author;
  final String length;
  final String bookLink;
  final String image;
  const OurAddBook(
      {Key? key,
      required this.groupName,
      required this.onGroupCreation,
      required this.bookLink,
      required this.name,
      required this.length,
      required this.author,
      required this.image})
      : super(key: key);

  @override
  State<OurAddBook> createState() => _OurAddBookState();
}

class _OurAddBookState extends State<OurAddBook> {
  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked =
        await DatePicker.showDateTimePicker(context, showTitleActions: true);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void addBook(BuildContext context, String groupName, OurBook book) async {
    CurrenState currenState = Provider.of<CurrenState>(context, listen: false);
    OurUser us = currenState.getCurrentUser;
    String returnString;
    if (widget.onGroupCreation) {
      returnString =
          await OurDatabase().createGroup(groupName, us.uid, book, us.fullname);
    } else {
      returnString = await OurDatabase().addBook(us.groupId, book, false);
    }
    if (returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController bookNameController =
        TextEditingController(text: widget.name);
    TextEditingController authorController =
        TextEditingController(text: widget.author);
    TextEditingController lengthController =
        TextEditingController(text: widget.length);
    TextEditingController linkCoontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Book",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xfff73366ff),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OurContainer(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: bookNameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.book),
                            hintText: "Book Name"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: authorController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.group), hintText: "Author"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: lengthController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          hintText: "Length",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: linkCoontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.link),
                          hintText: "Book Link",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //datepicker
                      Text(DateFormat.yMMMd("en_US").format(selectedDate)),
                      Text(selectedDate.hour.toString() +
                          ":" +
                          selectedDate.minute.toString()),
                      TextButton(
                          onPressed: () {
                            selectDate(context);
                          },
                          child: Text("Change Date")),

                      ElevatedButton(
                        onPressed: () {
                          OurBook book = OurBook(
                              id: widget.groupName,
                              name: bookNameController.text.trim(),
                              length: lengthController.text.trim(),
                              dateCompleted: Timestamp.fromDate(selectedDate),
                              author: authorController.text.trim(),
                              image: widget.image,
                              bookLink: linkCoontroller.text.trim());
                          addBook(context, widget.groupName, book);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          child: Text(
                            "Add Book",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
