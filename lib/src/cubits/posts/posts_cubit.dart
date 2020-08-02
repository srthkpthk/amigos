import 'package:amigos/src/model/postModel/PostEntity.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());
}
