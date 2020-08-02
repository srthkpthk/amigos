import 'package:amigos/src/cubits/posts/posts_cubit.dart';
import 'package:amigos/src/model/userModel/UserEntity.dart';
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
    );
  }
}
