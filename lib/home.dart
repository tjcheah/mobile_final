import 'dart:convert';
import '../wsocket_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://besquare-demo.herokuapp.com'),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SocketCubit(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Welcome ' + widget.title),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.sort_by_alpha),
                      label: Text('Sort'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.favorite),
                      label: Text('Favourite'),
                    ),
                  ],
                ),
                Column(
                  //where posts are shown
                  children: <Widget>[
                    BlocConsumer<SocketCubit, WebSocketChannel>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        state.sink.add('{"type": "get_posts"}');
                        return Center(
                          child: StreamBuilder(
                              stream: state.stream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.connectionState ==
                                        ConnectionState.done ||
                                    snapshot.connectionState ==
                                            ConnectionState.active &&
                                        snapshot.hasData) {
                                  final decode =
                                      jsonDecode(snapshot.data.toString())
                                          as Map;
                                  final posts = decode['data']['posts'] as List;
                                  print(posts);

                                  return SingleChildScrollView(
                                    physics: ScrollPhysics(),
                                    child: Center(
                                      child: ListView.builder(
                                          itemCount: posts.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 0),
                                              child: Card(
                                                elevation: 5,
                                                child: Column(
                                                  children: <Widget>[
                                                    Text('Title: ' +
                                                        posts[index]['title']),
                                                    Text(posts[index]
                                                        ['description']),
                                                    Image.network(
                                                        posts[index]['image']),
                                                    Text(posts[index]['date']),
                                                    Text('Written by ' +
                                                        posts[index]['author']),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  );
                                }
                                return const Center(
                                  child: Text('No data'),
                                );
                              }),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
