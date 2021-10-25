import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Random Activity',
      home: DataFromAPI(),
    );
  }
}

class DataFromAPI extends StatefulWidget {
  const DataFromAPI({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  getActivity() async {
    var response = await http.get(Uri.http("boredapi.com", "api/activity/"));
    var data = jsonDecode(response.body);
    Activity activity =
        Activity(data["activity"], data["type"], data["participants"]);
    return activity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Suggest an Activity"),
        ),
        body: Center(
          child: Column(
            children: [
              FutureBuilder<dynamic>(
                future: getActivity(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("Fetching Activity..."),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error!"),
                    );
                  } else {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(snapshot.data.activity),
                        Text(snapshot.data.type),
                        Text(snapshot.data.participants.toString()),
                      ],
                    ));
                  }
                },
              ),
              // ElevatedButton(
              //   child: const Text("Get Activity"),
              //   onPressed: () {
              //     getActivity();
              //   },
              // ),
            ],
          ),
        ));
  }
}

class Activity {
  final String activity, type;
  final int participants;

  Activity(this.activity, this.type, this.participants);
}
