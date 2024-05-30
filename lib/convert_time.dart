import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //menggunakan dateformat
import 'package:timer_builder/timer_builder.dart';

class ConvertTime extends StatefulWidget {
  const ConvertTime({Key? key}) : super(key: key);

  @override
  State<ConvertTime> createState() => _ConvertTimeState();
}

class _ConvertTimeState extends State<ConvertTime> {
  String getTime() {
    var Date = DateTime.now();
    return new DateFormat("HH : mm : ss")
        .format(Date.toUtc().add(Duration(hours: hours)));
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> zone = [
      DropdownMenuItem(child: Text("WIB"), value: "WIB"),
      DropdownMenuItem(child: Text("WITA"), value: "WITA"),
      DropdownMenuItem(child: Text("WIT"), value: "WIT"),
      DropdownMenuItem(child: Text("London"), value: "London"),
    ];
    return zone;
  }

  String selectedZone = "London";
  int hours = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Time Converter"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    child: Column(
                  children: [
                    TimerBuilder.periodic(Duration(seconds: 1),
                        builder: (context) {
                      print("${getTime()}");
                      return Text(
                        "${getTime()}  $selectedZone",
                        style: TextStyle(
                            color: Color(0xff2d386b),
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      );
                    }),
                  ],
                )),
                Container(
                    child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      child: DropdownButton(
                          value: selectedZone,
                          onChanged: (String? newZone) {
                            setState(() {
                              selectedZone = newZone!;
                              if (selectedZone == "WIB") {
                                hours = 7;
                              } else if (selectedZone == "WITA") {
                                hours = 8;
                              } else if (selectedZone == "WIT") {
                                hours = 9;
                              } else {
                                hours = 1;
                              }
                            });
                          },
                          items: dropdownItems),
                    )
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}
