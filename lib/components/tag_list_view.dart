import 'package:emodiary/components/auth_textfield.dart';
import 'package:emodiary/components/tag_card.dart';
import 'package:emodiary/database/db_provider.dart';
import 'package:emodiary/database/entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagListView extends StatefulWidget {
  const TagListView({super.key, this.onTap});
  final ValueChanged<Tag>? onTap;

  @override
  State<TagListView> createState() => _TagListViewState();
}

class _TagListViewState extends State<TagListView> {
  final nameCtl = TextEditingController();
  final colorCtl = TextEditingController();
  final scoredCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbProvider>(context);
    return Center(
      child: Column(
        children: [
          AuthTextfield(
              hintText: 'name', obscureText: false, controller: nameCtl),
          AuthTextfield(
              hintText: 'color', obscureText: false, controller: colorCtl),
          AuthTextfield(
              hintText: 'scored', obscureText: false, controller: scoredCtl),
          ElevatedButton(
            onPressed: () async {
              await dbProvider.dbService.createTag(
                Tag(
                  name: nameCtl.text, 
                  scored: int.parse(scoredCtl.text), 
                  color: colorCtl.text == '' ? null : int.parse(colorCtl.text)));
              nameCtl.clear();
              scoredCtl.clear();
              colorCtl.clear();
              setState(() {
                
              });
            },
            child: Text('Create')
          ),
          Divider(),
          FutureBuilder<List<Tag>>(
            future: dbProvider.dbService.getAllTags(), 
            builder:(context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No Exist Tag'),
                );
              } else {
                return Wrap(
                  spacing: 8,
                  runSpacing: 5,
                  children: [
                    for (Tag tag in snapshot.data!)
                      TagCard(
                        tag: tag, 
                        onTap:(value) {
                          widget.onTap!(value);
                        },
                      ),
                  ],
                );

              }
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameCtl.dispose();
    colorCtl.dispose();
    scoredCtl.dispose();
    super.dispose();
  }
}
