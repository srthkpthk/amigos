part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsEmpty extends PostsState {}

class PostsError extends PostsState {
  final String error;

  PostsError(this.error);
}

class PostPosted extends PostsState {}

class PostRefresh extends PostsState {
  final PostEntity postEntity;

  PostRefresh(this.postEntity);
}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts;

  PostsLoaded(this.posts);
}
