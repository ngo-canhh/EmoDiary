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
                                  MediaQuery.of(context).size.width * 0.8),
                          child: TagCard(tag: tags[index])),
                      Spacer(),
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
          _handleCreateTag(onSubmit: (color) async {
            if (nameCtl.text == '') {
              displayMessageToUser('Please add tag name', context).then((_) {
                return;
              });
            }
            await dbProvider.dbService.createTag(
                Tag(name: nameCtl.text, color: color.value, scored: 0));
            nameCtl.clear();
            setState(() {});
          });
        },
        child: FaIcon(FontAwesomeIcons.tag),
      ),
    );
  }

  void _handleCreateTag({required Function(Color color) onSubmit}) {
    Color pickerColor = Colors.green.shade300;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create new tag'),
          content: SingleChildScrollView(
              child: Column(
            children: [
              AuthTextfield(
                  hintText: 'Tag name',
                  obscureText: false,
                  controller: nameCtl),
              SizedBox(
                height: 10,
              ),
              MaterialPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (value) {
                    setState(() {
                      pickerColor = value;
                    });
                  })
            ],
          )),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onSubmit(pickerColor);
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
    );
  }

  @override
  void dispose() {
    nameCtl.dispose();
    super.dispose();
  }
}
