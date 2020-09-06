import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/services/database.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);
  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Subject'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

// ===================

class MultiSelect extends StatefulWidget {
  final String email;
  final String organisation;
  final String firstname;
  final String lastname;
  final String phone;

  const MultiSelect(
      {Key key,
      this.email,
      this.organisation,
      this.firstname,
      this.lastname,
      this.phone})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MultiSelect> {
  String value = "";

  List<MultiSelectDialogItem<int>> multiItem = List();

  List<ListItem> _classItems = [
    ListItem(1, "1"),
    ListItem(2, "2"),
    ListItem(3, "3"),
    ListItem(4, "4"),
    ListItem(5, "5"),
    ListItem(6, "6"),
    ListItem(7, "7"),
    ListItem(8, "8"),
    ListItem(9, "9")
  ];
  List<DropdownMenuItem<ListItem>> _dropdownMenuClass;
  ListItem _selectedClass;

  final valuestopopulate = {
    1: "English",
    2: "Hindi",
    3: "Marathi",
    4: "Geography",
  };
  var class_names = [];
  static var sub_names = [];

  void populateMultiselect() {
    for (int v in valuestopopulate.keys) {
      multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
    }
  }

  void initState() {
    super.initState();
    _dropdownMenuClass = buildDropDownMenuItems(_classItems);
    _selectedClass = _dropdownMenuClass[0].value;
  }

  void _showMultiSelect(BuildContext context) async {
    multiItem = [];
    populateMultiselect();
    final items = multiItem;

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
        );
      },
    );

    print(selectedValues);
    getvaluefromkey(selectedValues);
  }

  void getvaluefromkey(Set selection) {
    if (selection != null) {
      for (int x in selection.toList()) {
        print(valuestopopulate[x]);
        sub_names.add(valuestopopulate[x]);
      }
    }
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  String a;
  List b;
  Map<dynamic, dynamic> c;
  List<Map<dynamic, dynamic>> d = <Map<dynamic, dynamic>>[];

  void addItemToList() {
    setState(() {
      a = _selectedClass.name;
      b = sub_names;
      sub_names = [];
      FirebaseFirestore.instance
          .collection("Org")
          .doc(widget.organisation)
          .collection("Login")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({
        "fields": {
          "class": FieldValue.arrayUnion(["$a"]),
          "$a": FieldValue.arrayUnion(b),
        }
      }, SetOptions(merge: true));
      c = {a: b};
      d.add(c);
      print('$d');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          title: Text(
            "Class & Subject",
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Submit',
              onPressed: () {
                //Profile added to database
                Database().storeteacherinfo(
                    FirebaseAuth.instance.currentUser.uid,
                    widget.organisation,
                    widget.email,
                    widget.firstname,
                    widget.lastname,
                    widget.phone,
                    d,
                    context);
                Navigator.pushNamed(context, '/TeacherHomePage');
              },
            ),
          ],
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                top: 10.0, right: 10, left: 10, bottom: 10),
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue[100],
              border: Border.all(),
            ),
            child: DropdownButtonHideUnderline(
                child: DropdownButton(
              value: _selectedClass,
              items: _dropdownMenuClass,
              style: TextStyle(color: Colors.black, fontSize: 20),
              onChanged: (value) {
                setState(() {
                  _selectedClass = value;
                });
              },
            )),
          ),
          RaisedButton(
            child: Text("Choose Subject"),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.black),
            ),
            color: Colors.blue[100],
            padding: const EdgeInsets.all(20.0),
            onPressed: () => _showMultiSelect(context),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            color: Colors.blue[400],
            child: Text(
              'Add',
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.black),
            ),
            padding: const EdgeInsets.all(10.0),
            onPressed: () {
              addItemToList();
            },
          ),
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: d.length,
                  itemBuilder: (BuildContext context, int index) {
                    print("Entered Expanded");
                    return Container(
                      height: 50,
                      margin: EdgeInsets.all(2),
                      child: Center(
                          child: Text(
                        '${d[index]}',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
                    );
                  })),
        ])));
  }
}
