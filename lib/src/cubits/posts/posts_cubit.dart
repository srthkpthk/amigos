import 'dart:convert';
import 'dart:io';

import 'package:amigos/src/model/commentsModel/CommentEntity.dart';
import 'package:amigos/src/model/postModel/PostEntity.dart';
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
  final _postFirestore = Firestore.instance.collection('Posts');
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

      _postFirestore.add(PostEntity(
        'id',
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
      ).toJson());
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
//          .where('userId', whereIn: followingList)
//          .where('flags', isLessThan: 5)
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

  deletePost(String id) => _postFirestore.document(id).delete();

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
    _postFirestore
        .document(post.id)
        .updateData({'isFlagged': true, 'flaggedBy': userEntity.id});
  }

  Future<bool> alterLike(
      List<String> likeList, String id, String postId) async {
    if (likeList.contains(id)) {
      await _postFirestore
          .document(postId)
          .updateData({'likeList': likeList..remove(id)});
    } else {
      await _postFirestore
          .document(postId)
          .updateData({'likeList': likeList..add(id)});
    }
    return true;
  }

  addComment(PostEntity post, UserEntity userEntity, String text) {
    _postFirestore
        .document(post.id)
        .collection('Comments')
        .add(CommentEntity());
  }
}
