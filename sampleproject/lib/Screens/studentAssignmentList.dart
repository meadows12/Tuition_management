import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Screens/uploadAssign.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentAssignList extends StatefulWidget {
  final String clas;
  final String sub;

  const StudentAssignList({Key key, this.clas, this.sub}) : super(key: key);
  @override
  _StudentAssignListState createState() => _StudentAssignListState();
}

class _StudentAssignListState extends State<StudentAssignList> {
  List<Map<dynamic, dynamic>> values;

  Future getassignment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('orgname') ?? '';
    print(name);
  
    var query = await FirebaseFirestore.instance.collection('Org').doc(name).collection('Assignment').get();
      query.docs.forEach((doc) {

       values = List.from(doc.data()['${widget.clas}']['${widget.sub}']);
      });

      print(values);
      }



  void getlist() async{
    await getassignment();
  }       

  @override
  void initState() {
    
    getlist();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
    stream: FirebaseFirestore.instance.collection('Org').doc('Org 2').collection('Assignment').snapshots(),
    builder: (context, snapshot) {
      print(snapshot);
      if (snapshot.hasError)
        return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting: return new Text('Loading...');
        default:
          snapshot.data.docs.forEach((doc) {

       values = List.from(doc.data()['${widget.clas}']['${widget.sub}']);
      });
          return
            values != null ?
            new Scaffold(
                          body: ListView.builder(
          itemCount: values.length,
          itemBuilder: (context, position) {
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute<Null>(
                                      builder: (BuildContext context){
                                        return new Uploadassign(
                                          clas: widget.clas,
                                          sub: widget.sub,
                                          assign:values[position]['description'] ,
                                        );
                                      }
                                      ));
                },
                child: Card(
                  
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(values[position]['description'], style: TextStyle(fontSize: 22.0),),
                    
                  ),
                ),
              );
          }
              ),
              // floatingActionButton: FloatingActionButton(
              //   child: new Icon(Icons.add),
              //   onPressed: (){
              //     Navigator.of(context).push(MaterialPageRoute<Null>(
              //                         builder: (BuildContext context){
              //                           return new Uploadassign(
              //                             clas: widget.clas,
              //                             sub: widget.sub,
              //                           );
              //                         }
              //                         ));
              //   },
              // ),
            )
                :
            Center(
                child: Container(
                  width: 300,
                  child: Text(
                    'Error!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'acumin-pro',
                      fontSize: 22,
                    ),
                  ),
                )
            );
            
      }
    },
  );
  
  }

}