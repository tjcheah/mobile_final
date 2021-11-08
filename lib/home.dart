import 'dart:convert';
import 'package:flutter/rendering.dart';
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
                Expanded(
                  child: Column(
                    //where posts are shown
                    children: <Widget>[
                      BlocConsumer<SocketCubit, WebSocketChannel>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          state.sink.add('{"type": "get_posts"}');
                          return StreamBuilder(
                              stream: state.stream,
                              builder: (context, snapshot) {
                                //loading posts
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                //once response has posts
                                if (snapshot.connectionState ==
                                        ConnectionState.done ||
                                    snapshot.connectionState ==
                                            ConnectionState.active &&
                                        snapshot.hasData) {
                                  final decode =
                                      jsonDecode(snapshot.data.toString())
                                          as Map;
                                  final lists = decode['data']['posts'] as List;
                                  final posts = lists.reversed.toList();
                                  print(posts);
                                  state.sink.close();

                                  return Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: posts.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            child: Row(
                                              children: <Widget>[
                                                Column(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 10, 20, 10),
                                                      width: 150,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        image: const DecorationImage(
                                                            image: NetworkImage(
                                                                "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png"),
                                                            fit: BoxFit.cover),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: FadeInImage.assetNetwork(
                                                            image: posts[index][
                                                                        'image']
                                                                    ?.toString() ??
                                                                'https://mpama.com/wp-content/uploads/2017/04/default-image.jpg',
                                                            placeholder:
                                                                'assets/no_image.png',
                                                            fit: BoxFit.fill),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(0, 10, 0, 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          child: Text(
                                                            'Title: ' +
                                                                posts[index]
                                                                    ['title'],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20),
                                                          ),
                                                        ),
                                                        Text(
                                                          posts[index]
                                                              ['description'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                        Text(
                                                          'Written by ' +
                                                              posts[index]
                                                                  ['author'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                        Text(
                                                          posts[index]['date'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  );
                                }
                                return const Center(
                                  child: Text('No data'),
                                );
                              });
                        },
                      )
                    ],
                  ),
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
