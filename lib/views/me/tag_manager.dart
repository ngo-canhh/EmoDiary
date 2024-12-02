import 'package:emodiary/components/handle_create_tag.dart';
import 'package:emodiary/components/tag_card.dart';
import 'package:emodiary/provider/db_provider.dart';
import 'package:emodiary/helper/helper_function.dart';
import 'package:flutter/material.dart';
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
                            handleCreateTag(
                                tag: tags[index],
                                context: context,
                                tagNameController: nameCtl,
                                onSubmit: (newTag) async {
                                  if (newTag.name == '') {
                                    displayMessageToUser(
                                            'Please add tag name', context)
                                        .then((_) {
                                      return;
                                    });
                                  } else {
                                    await dbProvider.dbService
                                        .updateTag(newTag, tags[index].id!);
                                    setState(() {});
                                  }
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
          handleCreateTag(
              context: context,
              tagNameController: nameCtl,
              onSubmit: (newTag) async {
                if (newTag.name == '') {
                  displayMessageToUser('Please add tag name', context)
                      .then((_) {
                    return;
                  });
                } else {
                  await dbProvider.dbService.createTag(newTag);
                  setState(() {});
                }
              });
        },
        child: FaIcon(FontAwesomeIcons.tag),
      ),
    );
  }

  @override
  void dispose() {
    nameCtl.dispose();
    super.dispose();
  }
}
