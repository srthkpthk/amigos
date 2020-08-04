import 'dart:async';
import 'dart:io';

import 'package:amigos/src/model/postModel/PostEntity.dart';
import 'package:amigos/src/model/postModel/user.dart';
import 'package:amigos/src/model/userModel/UserEntity.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());
  final _fireStore = Firestore.instance.collection('Posts');
  final _firebaseStorage = FirebaseStorage.instance.ref();

  createPost(String description, File image, UserEntity userEntity,
      List<String> tags) async {
    if (description.isEmpty) {
      emit(PostsError('Provide some description'));
      return;
    }
    try {
      emit(PostsLoading());
      String _imageUrl;
      if (image != null) {
        StorageUploadTask _ut = _firebaseStorage
            .child('Posts/Users/${userEntity.id}/${image.path}')
            .putFile(image);
        await _ut.onComplete;
        _imageUrl = await _firebaseStorage
            .child('Posts/Users/${userEntity.id}/${image.path}')
            .getDownloadURL();
      }
      _fireStore.add(PostEntity(
              'id',
              DateTime.now().toString(),
              _imageUrl,
              description,
              0,
              0,
              [],
              tags,
              userEntity.id,
              User(userEntity.name, userEntity.isVerified,
                  userEntity.profileUrl, userEntity.userName, userEntity.id))
          .toJson());
      emit(PostPosted());
    } catch (e) {
      emit(PostsError('There was some error creating your post'));
    }
  }

  getPosts(List<String> followingList) {
    List<PostEntity> _posts = [];
    try {
      emit(PostsLoading());
      _fireStore
//          .where('userId', whereIn: ['KrqGHRlD3wRWb0sumzKafwvd2hg2'])
          .orderBy('postedAt', descending: true)
          .snapshots()
          .listen((event) {
        if (event.documents.isEmpty) {
          emit(PostsEmpty());
        } else {
          _posts = [];
          event.documents.forEach((element) {
            _posts.add(PostEntity.fromDocument(element));
            emit(PostsLoaded(_posts));
          });
        }
      });
    } catch (e) {
      emit(PostsError('Post Load Error'));
    }
  }

  addLike(List<String> likedList, String postId) =>
      _fireStore.document(postId).updateData({'likeList': likedList});
}
