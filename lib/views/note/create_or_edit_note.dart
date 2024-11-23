import 'dart:ui';

import 'package:emodiary/components/tag_card.dart';
import 'package:emodiary/components/tag_list_view.dart';
import 'package:emodiary/database/db_provider.dart';
import 'package:emodiary/database/entity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class CreateOrEditNote extends StatefulWidget {
  const CreateOrEditNote({super.key, this.existNote, this.existTags, this.selectDate});

  final Note? existNote;
  final List<Tag>? existTags;
  final DateTime? selectDate;

  @override
  State<CreateOrEditNote> createState() => _CreateOrEditNoteState();
}

class _CreateOrEditNoteState extends State<CreateOrEditNote> {
  late Note note;
  late Set<Tag> tags;
  late bool isNoteNew;

  bool isDirty = false;
  bool _showTagList = false;
  DbProvider? dbProvider;
  FocusNode titleFocus = FocusNode();
  FocusNode bodyFocus = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existNote == null) {
      note = Note(title: '', body: '', createdAt: widget.selectDate == null ? DateTime.now().toIso8601String() : widget.selectDate!.toIso8601String(), isPrivate: false);
      tags = <Tag>{};
      isNoteNew = true;
    } else {
      note = widget.existNote!;
      tags = widget.existTags!.toSet();
      isNoteNew = false;
    }
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
              SizedBox(height: 50,),
              // tag box
              Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (Tag tag in tags) 
                        TagCard(
                          tag: tag, 
                          onDoubleTap: (tag) {
                            setState(() {
                              isDirty = true;
                              tags.remove(tag);
                            });
                          },
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),

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
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                // height: 100,
                color: theme.primaryColor,
                child: SafeArea(
                  child: Row(
                    children: [
                      // back button
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        }, 
                        icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary,),
                      ),
                      Spacer(),

                      // hide button
                      IconButton(
                        onPressed: () {
                          // handle hide
                        }, 
                        icon: FaIcon(note.isPrivate ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, color: theme.colorScheme.onPrimary,),
                      ),

                      // add tag button
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showTagList = true;
                          });
                        }, 
                        icon: FaIcon(FontAwesomeIcons.tag, color: theme.colorScheme.onPrimary,),
                      ),

                      // delete button
                      IconButton(
                        onPressed: _handleDelete, 
                        icon: FaIcon(FontAwesomeIcons.trashCan, color: theme.colorScheme.onPrimary,),
                      ),

                      // Save button
                      if (isDirty)
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          margin: EdgeInsets.only(left: 10),
                          width: 110,
                          height: 40,
                          curve: Curves.decelerate,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(100),
                                  bottomLeft: const Radius.circular(100),
                                )
                              ) 
                            ),
                            onPressed: _handleSave, 
                            icon: FittedBox(child: Icon(Icons.done, color: theme.colorScheme.onPrimaryContainer,),),
                            label: Text(
                              'SAVE',
                              style: TextStyle(letterSpacing: 0, color: theme.colorScheme.onPrimaryContainer),
                            )
                          ),
                        ),
                    ],
                  )
                ),
              ),
            ),
          ),

          // tags list
          if (_showTagList) ... [
            AnimatedOpacity(
              opacity: 0.5,
              duration: Duration(milliseconds: 1000),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showTagList = false;
                  });
                },
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: AnimatedScale(
                scale: _showTagList ? 1 : 0.5,
                duration: Duration(milliseconds: 300),
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TagListView(
                        onTap: (tag) {
                          setState(() {
                            tags.add(tag);
                            isDirty = true;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showTagList = false;
                          });
                        },
                        child: Text("Close"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  void _handleDelete() async {
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
                )
              ),

              TextButton(
                onPressed: () {
                  context.pop();
                }, 
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    fontWeight:  FontWeight.w500,
                    letterSpacing: 1,
                  ),
                )
              ),
            ],
          );
        },
      );
    }
  }

  void _handleSave() async {
    setState(() {
      note.title = titleController.text;
      note.body = bodyController.text;
    });
    if (isNoteNew) {
      dbProvider!.createNote(note: note, tags: tags.toList());
    } else {
      dbProvider!.updateNote(note: note, tags: tags.toList());
    }
    setState(() {
      isDirty = isNoteNew = false;
    });

    titleFocus.unfocus();
    bodyFocus.unfocus();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}