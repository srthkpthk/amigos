import 'package:amigos/src/cubits/posts/posts_cubit.dart';
import 'package:amigos/src/model/postModel/PostEntity.dart';
import 'package:amigos/src/model/userModel/UserEntity.dart';
import 'package:amigos/src/ui/homeScreen/post_details_screen.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:toast/toast.dart';

enum PostModes { HomeScreen, DetailScreen }

class Post extends StatelessWidget {
  final PostEntity post;
  final UserEntity _userEntity;
  final _postCubit = PostsCubit();
  final _defaultCacheManager = DefaultCacheManager();
  final mode;

  Post(this.post, this._userEntity, this.mode);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: post.flags == 1
          ? Colors.red.withOpacity(.1)
          : post.flags == 2
              ? Colors.red.withOpacity(.3)
              : post.flags == 3
                  ? Colors.red.withOpacity(.5)
                  : post.flags == 4 ? Colors.red.withOpacity(.7) : null,
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
                        cacheManager: _defaultCacheManager,
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
                          Container(
                              width: MediaQuery.of(context).size.width < 400
                                  ? 60
                                  : null,
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text('@${post.user.userName} • ',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                          post.user.isVerified
                              ? Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: CircleAvatar(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    radius: 5,
                                    child: Icon(
                                      Icons.done,
                                      size: 9,
                                    ),
                                  ))
                              : Container(),
                          //todo add verified badge icon
                          Text(
                            timeAgo.format(DateTime.parse(post.postedAt),
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
                icon:
                    post.flags == 0 ? Icon(Icons.more_vert) : Icon(Icons.info),
                onPressed: () async {
//                  log(post.toDocument().toString());
                  _bottomSheet(context);
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
                child: Hero(
                  tag: post.id,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      post.description,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: OpenContainer(
                      transitionDuration: Duration(milliseconds: 450),
                      closedBuilder:
                          (BuildContext context, void Function() action) {
                        return GestureDetector(
                          onDoubleTap: () => _postCubit.alterLike(
                              post.likeList, _userEntity.id, post.id),
                          child: Hero(
                            tag: post.imagePath,
                            child: CachedNetworkImage(
                              cacheManager: _defaultCacheManager,
                              imageUrl: post.imagePath,
                              progressIndicatorBuilder: (_, __, ___) =>
                                  CircularProgressIndicator(),
                            ),
                          ),
                        );
                      },
                      openBuilder: (BuildContext context,
                          void Function({Object returnValue}) action) {
                        return Scaffold(
                          appBar: AppBar(
                            backgroundColor: Colors.black,
                            iconTheme: IconThemeData(color: Colors.white),
                          ),
                          body: PhotoView(
                              loadingBuilder: (_, __) =>
                                  Center(child: CircularProgressIndicator()),
                              imageProvider:
                                  CachedNetworkImageProvider(post.imagePath)),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  splashColor: Colors.pink,
                  splashRadius: 400,
                  icon: Icon(
                    post.likeList.contains(_userEntity.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: post.likeList.contains(_userEntity.id)
                        ? Colors.pink
                        : Colors.grey,
                  ),
                  onPressed: () => _postCubit.alterLike(
                      post.likeList, _userEntity.id, post.id)),
              Text(
                post.likeList.length == 0
                    ? 'Love it?'
                    : post.likeList.length.toString(),
                style: TextStyle(
                    color: post.likeList.contains(_userEntity.id)
                        ? Colors.pink
                        : Colors.grey.shade600),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    if (mode == PostModes.HomeScreen) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostDetailsScreen(
                                  post, _userEntity, _postCubit)));
                    }
                    _postCubit.addComment(post, _userEntity, 'hello');
                  }),
              Text(
                post.comments.length == 0
                    ? 'Comment'
                    : post.comments.length == 1
                        ? '${post.comments.length.toString()} Comment'
                        : '${post.comments.length.toString()} Comments',
                style: TextStyle(color: Colors.grey.shade600),
              )
            ],
          ),
          post.comments.isNotEmpty && mode == PostModes.HomeScreen
              ? InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostDetailsScreen(
                              post, _userEntity, _postCubit))),
                  child: Column(
                    children: [
                      Divider(
                        thickness: 1,
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                    cacheManager: _defaultCacheManager,
                                    height: 30,
                                    width: 30,
                                    imageUrl: post
                                        .comments[post.comments.length - 1]
                                        .by
                                        .profileUrl),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.comments[post.comments.length - 1].by
                                        .name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(post.comments[post.comments.length - 1]
                                      .comment)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  void _bottomSheet(BuildContext context) => showModalBottomSheet(
        context: context,
        enableDrag: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        builder: (BuildContext context) => Container(
          padding: EdgeInsets.all(25),
          child: Wrap(
            runSpacing: 5,
            children: [
              post.flags != 0 &&
                      _userEntity.id != post.user.userId &&
                      !post.flaggedBy.contains(_userEntity.id)
                  ? Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text('About this Post'),
                          subtitle: Text(
                              'This Post has been reported by ${post.flags} users for inappropriate content.\n If you find it true please report it '),
                        ),
                        Divider()
                      ],
                    )
                  : Container(),
              post.flags != 0 && _userEntity.id == post.user.userId
                  ? Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text('About this Post'),
                          subtitle: Text(
                              'Your Post has been reported by ${post.flags} users for inappropriate content'),
                        ),
                        Divider()
                      ],
                    )
                  : Container(),
              post.flags != 0 &&
                      _userEntity.id != post.user.userId &&
                      post.flaggedBy.contains(_userEntity.id)
                  ? Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text('About this Post'),
                          subtitle: Text(
                              'You have reported this post for inappropriate content \n The post is under review \n So far ${post.flags} users have reported this post as inappropriate'),
                        ),
                        Divider()
                      ],
                    )
                  : Container(),
              _userEntity.id == post.user.userId
                  ? ListTile(
                      title: Text(
                        'Delete Post',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _postCubit.deletePost(post.id);
                      },
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
                  Navigator.of(context).pop();
                  await FlutterShare.share(
                      title: 'Check what ${post.user.name} posted in Amigos',
                      text: 'Check what ${post.user.name} posted in Amigos',
                      linkUrl: await _postCubit.getDynamicLink(post.id),
                      //todo add post link
                      chooserTitle: 'Share to Friends');
                },
              ),
              ListTile(
                title: Text('Share to WhatsApp'),
                leading: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Color.fromRGBO(37, 211, 102, 1),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  FlutterShareMe().shareToWhatsApp(
                      msg:
                          'Hey! Check What *${post.user.name}* Shared on Amigos. (  *${post.description.trimRight()}*  ) ',
                      base64Image: post.imagePath == null
                          ? null
                          : 'data:image/jpeg;base64,${await _postCubit.getBase64Image(_defaultCacheManager.getSingleFile(post.imagePath))}');
                },
              ),
              _userEntity.id != post.user.userId &&
                      !post.flaggedBy.contains(_userEntity.id)
                  ? ListTile(
                      title: Text(
                        'Report',
                      ),
                      leading: Icon(
                        Icons.change_history,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Toast.show(
                            '${post.user.name}\'s Post ${post.description} has been reported to the admins for Reviewing purpose. Check other Posts in meantime . Thanks for your contribution',
                            context,
                            duration: 3);
                        _postCubit.reportPost(post, _userEntity);
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      );
}
