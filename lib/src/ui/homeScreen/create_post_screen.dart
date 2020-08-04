import 'dart:io';

import 'package:amigos/src/cubits/posts/posts_cubit.dart';
import 'package:amigos/src/model/userModel/UserEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../../../res.dart';

class CreatePostScreen extends StatefulWidget {
  final UserEntity _userEntity;

  CreatePostScreen(this._userEntity);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final picker = ImagePicker();
  File _image;
  final TextEditingController _editingController = TextEditingController();
  final _bloc = PostsCubit();
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _bloc,
      listener: (BuildContext context, state) {
        if (state is PostPosted) {
          Navigator.pop(context);
        }
        if (state is PostsError) {
          Toast.show(state.error, context);
        }
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 50,
              bottom: MediaQuery.of(context).viewInsets.bottom + 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BlocBuilder(
                                  cubit: _bloc,
                                  builder: (BuildContext context, state) {
                                    return state is PostsLoading
                                        ? Image.asset(Res.small_logo_loading)
                                        : Image.asset(Res.small_logo);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    icon: Icon(Icons.photo),
                                    onPressed: () =>
                                        _getImage(ImageSource.gallery)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () =>
                                        _getImage(ImageSource.camera)),
                              )
                            ],
                          ),
                          FloatingActionButton(
                            onPressed: () => _bloc.createPost(
                                _editingController.text,
                                _image,
                                widget._userEntity, []),
                            child: Icon(Icons.done),
                          )
                        ],
                      )),
                  VerticalDivider(
                    thickness: 1,
                    width: 2,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          showCursor: false,
                          keyboardType: TextInputType.text,
                          controller: _editingController,
                          maxLines: 4,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            labelText: 'Share Some Thoughts...',
                          ),
                        ),
                        _image == null
                            ? Container()
                            : Divider(
                                thickness: 2,
                              ),
                        _image == null
                            ? Container()
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(_image),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  _getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);
    setState(() {
      _image = File(pickedFile.path);
    });
  }
}
