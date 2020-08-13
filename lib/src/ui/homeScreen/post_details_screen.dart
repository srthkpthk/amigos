import 'package:amigos/src/cubits/posts/posts_cubit.dart';
import 'package:amigos/src/model/postModel/PostEntity.dart';
import 'package:amigos/src/model/userModel/UserEntity.dart';
import 'package:flutter/material.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostEntity postEntity;
  final UserEntity userEntity;
  final PostsCubit postsCubit;

  PostDetailsScreen(this.postEntity, this.userEntity, this.postsCubit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(postEntity.description),
        ),
      ),
    );
  }
}
