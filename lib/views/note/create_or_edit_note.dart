import 'dart:ui';

import 'package:emodiary/components/tag_card.dart';
import 'package:emodiary/components/tag_list_view.dart';
import 'package:emodiary/provider/db_provider.dart';
import 'package:emodiary/database/entity.dart';
import 'package:emodiary/views/note/image_list_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class CreateOrEditNote extends StatefulWidget {
  const CreateOrEditNote(
      {super.key, this.existNote, this.existTags, this.selectDate, this.title});

  final Note? existNote;
  final List<Tag>? existTags;
  final DateTime? selectDate;
  final String? title;

  @override
  State<CreateOrEditNote> createState() => _CreateOrEditNoteState();
}

class _CreateOrEditNoteState extends State<CreateOrEditNote> {
  late Note note;
  late Set<Tag> tags;
  late bool isNoteNew;
  late Set<String> preImages;
  late Set<String> toShowImages;

  bool isDirty = false;
  DbProvider? dbProvider;
  FocusNode titleFocus = FocusNode();
  FocusNode bodyFocus = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existNote == null) {
      note = Note(
          title: widget.title ?? '',
          body: '',
          createdAt: widget.selectDate == null
              ? DateTime.now().toIso8601String()
              : widget.selectDate!.toIso8601String(),
          isPrivate: false);
      tags = <Tag>{};
      isDirty = widget.title != null;
      isNoteNew = true;
    } else {
      note = widget.existNote!;
      tags = widget.existTags!.toSet();
      isNoteNew = false;
    }
    preImages = note.mediaUrls == null ? {} : note.mediaUrls!.trim().split(' ').toSet();
    toShowImages = {};
    toShowImages.addAll(preImages);
    titleController.text = note.title!;
    bodyController.text = note.body!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    dbProvider ??= Provider.of<DbProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 55,
              ),

              // tag box
              if (tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (Tag tag in tags)
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: TagCard(
                              tag: tag,
                              onDoubleTap: (tag) {
                                setState(() {
                                  isDirty = true;
                                  tags.remove(tag);
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              if (toShowImages.isNotEmpty)
                Column(
                  children: [
                    ImageListView(
                      imagePaths: toShowImages.toList(),
                      maxHeight: 150,
                      onDoubleTap: (imagePath) {
                        setState(() {
                          toShowImages.remove(imagePath);
                          isDirty = true;
                        });
                      },
                    ),
                    Divider(),
                  ],
                ),

              // Title textfield
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  focusNode: titleFocus,
                  autofocus: true,
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSubmitted: (value) {
                    titleFocus.unfocus();
                    FocusScope.of(context).requestFocus(bodyFocus);
                  },
                  onChanged: (value) {
                    setState(() {
                      isDirty = true;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Title ...',
                    hintStyle: TextStyle(
                      color: theme.hintColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              // Body textfield
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  focusNode: bodyFocus,
                  autofocus: true,
                  controller: bodyController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      isDirty = true;
                    });
                  },
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'What are you thinking ...',
                    hintStyle: TextStyle(
                      color: theme.hintColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),

          // Tools
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                height: 100,
                color: theme.colorScheme.secondaryContainer,
                child: SafeArea(
                    child: Row(
                  children: [
                    // back button
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                    Spacer(),

                    // hide button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          note.isPrivate = !note.isPrivate;
                          isDirty = true;
                        });
                      },
                      icon: FaIcon(
                        note.isPrivate
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        color: theme.colorScheme.onSecondaryContainer,
                        size: 18,
                      ),
                    ),

                    // add tag button
                    IconButton(
                      onPressed: () {
                        _handleAddTag(addTag: (tag) {
                          setState(() {
                            tags.add(tag);
                            isDirty = true;
                          });
                        });
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.tag,
                        color: theme.colorScheme.onSecondaryContainer,
                        size: 18,
                      ),
                    ),

                    // add photo button
                    PopupMenuButton<bool>(
                      icon: FaIcon(
                        FontAwesomeIcons.photoFilm,
                        color: theme.colorScheme.onSecondaryContainer,
                        size: 18,
                      ),
                      onSelected: (value) {
                        _handleAddPhoto(value);
                      },
                      itemBuilder:(context) => <PopupMenuEntry<bool>>[
                        PopupMenuItem<bool>(
                          value: true,
                          child: Text('Camera')),
                        PopupMenuItem<bool>(
                          value: false,
                          child: Text('Gallery')),
                      ],
                    ),

                    // IconButton(
                    //   onPressed: () {
                    //     _handleAddPhoto();
                    //   },
                    //   icon: FaIcon(
                    //     FontAwesomeIcons.photoFilm,
                    //     color: theme.colorScheme.onSecondaryContainer,
                    //     size: 18,
                    //   ),
                    // ),

                    // delete button
                    IconButton(
                      onPressed: _handleDeleteNote,
                      icon: FaIcon(
                        FontAwesomeIcons.trashCan,
                        color: theme.colorScheme.onSecondaryContainer,
                        size: 18,
                      ),
                    ),

                    // Save button
                    if (isDirty)
                      GestureDetector(
                        onTap: _handleSaveNote,
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSecondaryContainer,
                            borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(100),
                                    bottomLeft: const Radius.circular(100),
                          ),),
                          width: 50,
                          height: 40,
                          curve: Curves.decelerate,
                          child: Icon(Icons.check, color: theme.colorScheme.secondaryContainer,))
                        ),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddPhoto(bool isPickFromCamera) async {
    final ImagePicker picker = ImagePicker();

    if (isPickFromCamera) {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          toShowImages.add(image.path);
          isDirty = true;
        });
      } 
    } else {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          toShowImages.addAll(images.map((e) => e.path));
          isDirty = true;
        });
      }
    }

  }

  void _handleDeleteNote() async {
    if (isNoteNew) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text('Delete note'),
            content: Text('This note will be deleted permanently'),
            actions: [
              TextButton(
                  onPressed: () async {
                    await dbProvider!.deleteNote(note);
                    // Navigator.popUntil(context, ModalRoute.withName('/home/calendar'));
                    Navigator.pop(context);
                    // if (Navigator.canPop(context)) Navigator.pop(context);
                    context.pop();
                  },
                  child: Text(
                    'DELETE',
                    style: TextStyle(
                      color: Colors.red.shade300,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  )),
            ],
          );
        },
      );
    }
  }

  void _handleSaveNote() async {
    Set<String> toDels = preImages.difference(toShowImages);
    Set<String> toSaves = toShowImages.difference(preImages);

    if (toDels.isNotEmpty) {
      await dbProvider?.delImages(toDels);
    }

    Set<String> saved = {};
    if (toSaves.isNotEmpty) {
      final temp = await dbProvider?.saveImages(toSaves);
      saved.addAll(temp!);
    }
    saved.addAll(preImages.intersection(toShowImages));

    setState(() {
      note.title = titleController.text;
      note.body = bodyController.text;
      note.mediaUrls = saved.isNotEmpty ? saved.join(' ') : null;
    });
    if (isNoteNew) {
      dbProvider!.createNote(note: note, tags: tags.toList());
    } else {
      dbProvider!.updateNote(note: note, tags: tags.toList());
    }
    setState(() {
      isDirty = isNoteNew = false;
      preImages.clear();
      toShowImages.clear();
      preImages.addAll(saved);
      toShowImages.addAll(saved);
  
    });

    titleFocus.unfocus();
    bodyFocus.unfocus();
  }

  void _handleAddTag({required Function(Tag tag) addTag}) {
    showDialog(
      context: context,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6),
          child: AlertDialog(
            title: Text('Tags'),
            content: TagListView(
              onTap: (tag) {
                addTag(tag);
              },
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Done'))
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}


