import 'package:amigos/src/cubits/posts/posts_cubit.dart';
import 'package:amigos/src/model/postModel/PostEntity.dart';
import 'package:amigos/src/model/userModel/UserEntity.dart';
import 'package:amigos/src/ui/homeScreen/create_post_screen.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../res.dart';

class HomeScreen extends StatelessWidget {
  final UserEntity _userEntity;
  final _postsCubit = PostsCubit();
  HomeScreen(this._userEntity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Amigos.',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder(
            cubit: _postsCubit,
            builder: (BuildContext context, state) => state is PostsLoading
                ? Image.asset(Res.small_logo_loading)
                : Image.asset(Res.small_logo),
          ),
        ),
      ),
      body: Row(
        children: <Widget>[
          Container(
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    imageUrl: _userEntity.profileUrl,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: FloatingActionButton(
                        child: Icon(Icons.add),
                        elevation: 60,
                        onPressed: () => showModal(
                            configuration: FadeScaleTransitionConfiguration(
                                transitionDuration: Duration(milliseconds: 450),
                                reverseTransitionDuration:
                                    Duration(milliseconds: 450)),
                            context: context,
                            builder: (context) =>
                                CreatePostScreen(_userEntity)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 2,
          ),
          Expanded(
              child: BlocBuilder(
            cubit: _postsCubit,
            builder: (BuildContext context, state) {
              if (state is PostsInitial) {
                _postsCubit.getPosts(_userEntity.followingList);
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PostsEmpty) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'No Posts Currently Wanna Refresh',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FlatButton(
                        onPressed: () {
                          _postsCubit.getPosts(_userEntity.followingList);
                        },
                        child: Text('Retry'),
                      )
                    ],
                  ),
                );
              }
              if (state is PostsError) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Some Error Occurred Wanna Refresh',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FlatButton(
                        onPressed: () {
                          _postsCubit.getPosts(_userEntity.followingList);
                        },
                        child: Text('Retry'),
                      )
                    ],
                  ),
                );
              }
              if (state is PostsLoaded) {
                return RefreshIndicator(
                  onRefresh: () async =>
                      await _postsCubit.getPosts(_userEntity.followingList),
                  child: ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildListChild(state.posts[index]);
                    },
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
        ],
      ),
    );
  }

  _buildListChild(PostEntity post) => Card(
        margin: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: post.user.profileUrl,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    VerticalDivider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '@${post.user.userName} •',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(post.user.name)
                      ],
                    ),
                  ],
                ),
                IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
              ],
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              color: Colors.grey,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    post.description,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                post.imagePath == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: post.imagePath,
                              progressIndicatorBuilder: (_, __, ___) =>
                                  CircularProgressIndicator(),
                            )),
                      )
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      post.likeList.contains(_userEntity.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      if (post.likeList.contains(_userEntity.id)) {
                        _postsCubit.addLike(
                            post.likeList..remove(_userEntity.id), post.id);
                      } else {
                        _postsCubit.addLike(
                            post.likeList..add(_userEntity.id), post.id);
                      }
                    }),
                SizedBox(
                  width: 10,
                ),
                IconButton(icon: Icon(Icons.message), onPressed: () {}),
              ],
            )
          ],
        ),
      );
}
