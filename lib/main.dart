import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_final/home.dart';
import '../wsocket_cubit.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Final Project',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BlocProvider(
        create: (context) => SocketCubit(),
        child: Login(title: 'Sign in'),
      ),
    );
  }
}

class Login extends StatefulWidget {
  Login({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController username = TextEditingController();
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://besquare-demo.herokuapp.com'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: username,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter username',
              ),
            ),
            BlocBuilder<SocketCubit, WebSocketChannel>(
              builder: (context, state) {
                return StreamBuilder(
                    stream: state.stream,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                          onPressed: () {
                            if (username.text.isNotEmpty) {
                              state.sink.add(
                                  '{"type": "sign_in", "data": {"name": "${username.text}"}}');
                              print(
                                  '{"type": "sign_in", "data": {"name": "${username.text}"}}');
                            }
                            var decode = jsonDecode(snapshot.data.toString());
                            var response = decode['data']['response'];
                            print(decode);

                            print(response);
                            if (response == "OK") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(
                                            title: username.text,
                                          )));
                            }
                          },
                          child: const Text('Enter App'));
                    });
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
