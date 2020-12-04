import 'dart:convert';
import 'dart:io';

import 'package:amigos/src/model/postModel/PostEntity.dart';
import 'package:amigos/src/model/postModel/comments.dart';
import 'package:amigos/src/model/postModel/user.dart';
import 'package:amigos/src/model/userModel/UserEntity.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());
  final _postFirestore = FirebaseFirestore.instance.collection('Posts');
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
        UploadTask _ut = _firebaseStorage
            .child('Posts/Users/${userEntity.id}/${image.path}')
            .putFile(image);
        _imageUrl = await _firebaseStorage
            .child('Posts/Users/${userEntity.id}/${image.path}')
            .getDownloadURL();
      }

      _postFirestore.add(PostEntity(
          DateTime.now().toString(),
          _imageUrl,
          0,
          description,
          [],
          tags,
          [],
          userEntity.id,
          User(userEntity.name, userEntity.isVerified, userEntity.profileUrl,
              userEntity.userName, userEntity.id),
          []).toDocument());
      emit(PostPosted());
    } catch (e) {
      emit(PostsError('There was some error creating your post'));
    }
  }

  getPosts(List<String> followingList) {
    List<PostEntity> _posts = [];
    try {
      emit(PostsLoading());
      _postFirestore
//          .orderBy('flags')
          .orderBy('postedAt', descending: true)
//          .where('userId', whereIn: followingList)
//          .where('flags', isLessThanOrEqualTo: 4)
          .snapshots()
          .listen((event) {
        if (event.docs.isEmpty) {
          emit(PostsEmpty());
        } else {
          _posts = [];
          event.docs.forEach((element) {
            _posts.add(PostEntity.fromDocument(element));
            emit(PostsLoaded(_posts));
          });
        }
      });
    } catch (e) {
      emit(PostsError('Post Load Error'));
    }
  }

  deletePost(String id) => _postFirestore.doc(id).delete();

  getDynamicLink(String id) async {
    var parameters = await DynamicLinkParameters(
      uriPrefix: 'https://srthk.page.link',
      androidParameters: AndroidParameters(
        packageName: 'srthk.pthk.amigos',
        minimumVersion: 125,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.ios',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      link: Uri.parse('https://srthk.page.link/post=$id'),
    ).buildShortLink();
    final Uri shortUrl = parameters.shortUrl;
    print(shortUrl);
    return shortUrl.toString();
  }

  getBase64Image(Future<File> singleFile) async {
    File _file = await singleFile;
    return base64Encode(_file.readAsBytesSync());
  }

  reportPost(PostEntity post, UserEntity userEntity) {
    post.flaggedBy..add(userEntity.id);
    _postFirestore
        .doc(post.id)
        .update({'flags': post.flags + 1, 'flaggedBy': post.flaggedBy});
  }

  Future<bool> alterLike(
      List<String> likeList, String id, String postId) async {
    if (likeList.contains(id)) {
      await _postFirestore
          .doc(postId)
          .update({'likeList': likeList..remove(id)});
    } else {
      await _postFirestore.doc(postId).update({'likeList': likeList..add(id)});
    }
    return true;
  }

  addComment(PostEntity post, UserEntity userEntity, String text) {
    post.comments
      ..add(Comments(
          User(userEntity.name, false, userEntity.profileUrl,
              userEntity.userName, userEntity.id),
          text,
          [],
          post.comments.length + 1,
          []));
    _postFirestore
        .doc(post.id)
        .update({'comments': post.comments.map((e) => e.toJson()).toList()});
  }
}
