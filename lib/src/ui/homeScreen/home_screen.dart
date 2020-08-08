import 'dart:developer';

import 'package:amigos/src/cubits/posts/posts_cubit.dart';
import 'package:amigos/src/model/postModel/PostEntity.dart';
import 'package:amigos/src/model/userModel/UserEntity.dart';
import 'package:amigos/src/ui/homeScreen/create_post_screen.dart';
import 'package:amigos/src/ui/widgets/post.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:photo_view/photo_view.dart';
import 'package:random_color/random_color.dart';
import 'package:swipedetector/swipedetector.dart';

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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: _userEntity.profileUrl,
                    ),
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
                      return Post(state.posts[index], _userEntity);
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
}
