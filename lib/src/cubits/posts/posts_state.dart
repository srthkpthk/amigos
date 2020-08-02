part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsEmpty extends PostsState {}

class PostsError extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts;

  PostsLoaded(this.posts);
}
