// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:io';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {



  var text = " ";
  TextEditingController ip = TextEditingController();
  var ipAddress="192.168.47.174";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "RFID Project",
          ),
          backgroundColor: Colors.green,
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text('Enter PC IP Address'),
                /*TextFormField(
                  scrollPadding: const EdgeInsets.all(20),
                  controller: ip ,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(

                    labelText: "Enter PC IP Address",
                    hintText: "Ex 172.20.10.7",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(

                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(

                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),

                ),*/

                ElevatedButton(
                  onPressed: ()   async {

                    setState(() {
                      text=" ";
                    });
                    // _ndefWrite();

                    // nfc part
                    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
                      Map<String, dynamic> tagData= tag.data;
                      print(tagData);

                      //socket part
                       final socket = await Socket.connect(ipAddress, 8089);
                       socket.write(tagData["ndef"]);

                      //Map<dynamic, dynamic> data = tagData["ndef"];
                      //data = json.decode(tagData.values.elementAt(2));
                      //print(data.values);
                      //var target_list_2 = List<dynamic>.from(tagData);
                      //print(tagData.toString());
                      setState(() {
                        text="The tag has been read and the data sent to the client";
                      });
                      //print(tagJSON.cachedMessage);

                      //print(tagData['ndef']['cachedMessage']["records"]["payload"]);
                      NfcManager.instance.stopSession();
                    });




                  },
                  child: Text('Read The Card'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    elevation: 10,
                  ),
                ),
                Text("\n$text", style: TextStyle(fontSize: 15))

              ],
            )));
  }
}













