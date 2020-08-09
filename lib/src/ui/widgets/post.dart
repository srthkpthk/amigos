import 'package:amigos/src/cubits/posts/posts_cubit.dart';
import 'package:amigos/src/model/postModel/PostEntity.dart';
import 'package:amigos/src/model/userModel/UserEntity.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:photo_view/photo_view.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatelessWidget {
  final PostEntity post;
  final UserEntity _userEntity;
  final _postCubit = PostsCubit();

  Post(this.post, this._userEntity);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: post.user.profileUrl,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            '@${post.user.userName} • ',
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            timeago.format(DateTime.parse(post.postedAt),
                                allowFromNow: true, locale: 'en_short'),
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          )
                        ],
                      ),
                      Text(post.user.name)
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    enableDrag: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    builder: (BuildContext context) => Container(
                      padding: EdgeInsets.all(25),
                      child: Wrap(
                        runSpacing: 5,
                        children: [
                          _userEntity.id == post.user.userId
                              ? ListTile(
                                  title: Text(
                                    'Delete Post',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () => _postCubit.deletePost(post.id),
                                  leading: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              : Container(),
                          _userEntity.id == post.user.userId
                              ? ListTile(
                                  title: Text(
                                    'Edit Post',
                                  ),
                                  leading: Icon(
                                    Icons.edit,
                                  ),
                                )
                              : Container(),
                          ListTile(
                            title: Text('Share'),
                            leading: Icon(Icons.share),
                            onTap: () async {
                              await FlutterShare.share(
                                  title:
                                      'Check what ${post.user.name} posted in Amigos',
                                  text:
                                      'Check what ${post.user.name} posted in Amigos',
                                  linkUrl: await _postCubit.getDynamicLink(post.id),
                                  //todo add post link
                                  chooserTitle: 'Share to Friends');
                            },
                          ),
                          _userEntity.id != post.user.userId
                              ? ListTile(
                                  title: Text(
                                    'Report',
                                  ),
                                  leading: Icon(
                                    Icons.change_history,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            color: Colors.grey,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  post.description,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              if (post.tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                      spacing: 6,
                      runSpacing: 5,
                      children: post.tags.map((e) {
                        return Chip(
                            padding: EdgeInsets.all(8),
                            backgroundColor: Theme.of(context).accentColor,
                            labelStyle: TextStyle(color: Colors.white),
                            label: Text('#$e'));
                      }).toList()),
                ),
              if (post.imagePath == null)
                Container()
              else
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: OpenContainer(
                    transitionDuration: Duration(milliseconds: 450),
                    closedBuilder:
                        (BuildContext context, void Function() action) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onDoubleTap: () => _alterLike(post),
                            child: CachedNetworkImage(
                              imageUrl: post.imagePath,
                              progressIndicatorBuilder: (_, __, ___) =>
                                  CircularProgressIndicator(
                                value: ___.downloaded.toDouble(),
                              ),
                            ),
                          ));
                    },
                    openBuilder: (BuildContext context,
                        void Function({Object returnValue}) action) {
                      return SwipeDetector(
                        onSwipeDown: () => Navigator.pop(context),
                        child: PhotoView(
                            loadingBuilder: (_, __) =>
                                Center(child: CircularProgressIndicator()),
                            imageProvider:
                                CachedNetworkImageProvider(post.imagePath)),
                      );
                    },
                  ),
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
                  onPressed: () => _alterLike(post)),
              Text(
                post.likeList.length == 0
                    ? ''
                    : post.likeList.length.toString(),
                style: TextStyle(
                    color: post.likeList.contains(_userEntity.id)
                        ? Colors.pink
                        : Colors.grey.shade600),
              ),
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

  _alterLike(PostEntity post) {
    if (post.likeList.contains(_userEntity.id)) {
      _postCubit.addLike(post.likeList..remove(_userEntity.id), post.id);
    } else {
      _postCubit.addLike(post.likeList..add(_userEntity.id), post.id);
    }
  }


}
