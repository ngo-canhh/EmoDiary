import 'package:emodiary/components/auth_textfield.dart';
import 'package:emodiary/components/tag_card.dart';
import 'package:emodiary/database/db_provider.dart';
import 'package:emodiary/database/entity.dart';
import 'package:emodiary/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TagManager extends StatefulWidget {
  const TagManager({super.key});

  @override
  State<TagManager> createState() => _TagManagerState();
}

class _TagManagerState extends State<TagManager> {
  TextEditingController nameCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DbProvider dbProvider = Provider.of<DbProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Manager'),
      ),
      body: FutureBuilder(
        future: dbProvider.dbService.getAllTags(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text('No Exist Tag'),
            );
          } else {
            final tags = snapshot.data!;
            return ListView.builder(
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                          child: TagCard(tag: tags[index])),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            _handleEditTag(
                                tag: tags[index], onSubmit: (newTag) async {
                                  if (nameCtl.text == '') {
                                    displayMessageToUser('Please add tag name', context).then((_) {
                                      return;
                                    });
                                  }
                                  await dbProvider.dbService.updateTag(
                                      newTag, tags[index].id!);
                                  setState(() {});
                                });
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    "This tag will be permanently deleted!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        dbProvider.deleteTag(tags[index]);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel')),
                                ],
                              );
                            },
                          );
                        },
                        icon: const FaIcon(FontAwesomeIcons.deleteLeft),
                        iconSize: 20,
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _handleCreateTag(onSubmit: (color, scored) async {
            if (nameCtl.text == '') {
              displayMessageToUser('Please add tag name', context).then((_) {
                return;
              });
            }
            await dbProvider.dbService.createTag(
                Tag(name: nameCtl.text, color: color.value, scored: scored));
            setState(() {});
          });
        },
        child: FaIcon(FontAwesomeIcons.tag),
      ),
    );
  }

  void _handleCreateTag({required Function(Color color, int scored) onSubmit}) {
    Color pickerColor = Colors.green.shade300;
    int scored = 5;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create new tag'),
          content: SingleChildScrollView(
              child: StatefulBuilder(
            builder: (context, setDialogState) => Column(
              children: [
                AuthTextfield(
                    hintText: 'Tag name',
                    obscureText: false,
                    controller: nameCtl),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Text(
                            'Color',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                          MaterialPicker(
                              pickerColor: pickerColor,
                              onColorChanged: (value) {
                                setDialogState(() {
                                  pickerColor = value;
                                });
                              }),
                        ],
                      ),
                    ),
                    SizedBox(width: 5, child: VerticalDivider()),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'Scored',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                            ...List.generate(11, (index) {
                              return ChoiceChip(
                                label: Text(
                                  '$index',
                                  style: TextStyle(
                                    color: scored == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                selected: scored == index,
                                selectedColor: pickerColor,
                                onSelected: (isSelected) {
                                  // if (!isSelected) {
                                  setDialogState(() {
                                    scored = index;
                                  });
                                  // }
                                },
                              );
                            }),
                          ],
                        ))
                  ],
                )
              ],
            ),
          )),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onSubmit(pickerColor, scored);
                },
                child: Text('Create')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'))
          ],
        );
      },
    ).then((_) {
      nameCtl.clear();
    });
  }

  void _handleEditTag(
      {required Tag tag, required Function(Tag newTag) onSubmit}) {
    Color pickerColor = Color(tag.color!);
    int scored = tag.scored;
    nameCtl.text = tag.name;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit tag'),
          content: SingleChildScrollView(
              child: StatefulBuilder(
            builder: (context, setDialogState) => Column(
              children: [
                AuthTextfield(
                    hintText: 'Tag name',
                    obscureText: false,
                    controller: nameCtl),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Text(
                            'Color',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                          MaterialPicker(
                              pickerColor: pickerColor,
                              onColorChanged: (value) {
                                setDialogState(() {
                                  pickerColor = value;
                                });
                              }),
                        ],
                      ),
                    ),
                    SizedBox(width: 5, child: VerticalDivider()),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'Scored',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                            ...List.generate(11, (index) {
                              return ChoiceChip(
                                label: Text(
                                  '$index',
                                  style: TextStyle(
                                    color: scored == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                selected: scored == index,
                                selectedColor: pickerColor,
                                onSelected: (isSelected) {
                                  // if (!isSelected) {
                                  setDialogState(() {
                                    scored = index;
                                  });
                                  // }
                                },
                              );
                            }),
                          ],
                        ))
                  ],
                )
              ],
            ),
          )),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onSubmit(Tag(
                      id: tag.id,
                      name: nameCtl.text,
                      color: pickerColor.value,
                      scored: scored));
                },
                child: Text('Update')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'))
          ],
        );
      },
    ).then((_) {
      nameCtl.clear();
    });
  }

  @override
  void dispose() {
    nameCtl.dispose();
    super.dispose();
  }
}
