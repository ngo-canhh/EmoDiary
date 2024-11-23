import 'package:emodiary/components/auth_textfield.dart';
import 'package:emodiary/components/tag_card.dart';
import 'package:emodiary/database/db_provider.dart';
import 'package:emodiary/database/entity.dart';
import 'package:emodiary/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class TagListView extends StatefulWidget {
  const TagListView({super.key, this.onTap});
  final ValueChanged<Tag>? onTap;

  @override
  State<TagListView> createState() => _TagListViewState();
}

class _TagListViewState extends State<TagListView> {
  final nameCtl = TextEditingController();

  // final scoredCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbProvider>(context);
    return Center(
      child: Column(
        children: [
          FutureBuilder<List<Tag>>(
            future: dbProvider.dbService.getAllTags(), 
            builder:(context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Text('No exist tag', style: TextStyle(fontSize: 24),),
                      SizedBox(height: 10,),
                      GestureDetector(
                              onTap: () {
                                _handleCreateTag(
                                  onSubmit: (color) async {
                                    if (nameCtl.text == '') {
                                      displayMessageToUser('Please add tag name', context).then((_) {return;});
                                    }
                                    await dbProvider.dbService.createTag(Tag(name: nameCtl.text, color: color.value, scored: 0));
                                    nameCtl.clear();
                                    setState(() {
                                      
                                    });
                                  }
                                );
                              },
                              child: Container(
                                height: 40, 
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimaryContainer, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Create tag',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.6, 
                  margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
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
                        
                        GestureDetector(
                          onTap: () {
                            _handleCreateTag(
                              onSubmit: (color) async {
                                if (nameCtl.text == '') {
                                  displayMessageToUser('Please add tag name', context).then((_) {return;});
                                }
                                await dbProvider.dbService.createTag(Tag(name: nameCtl.text, color: color.value, scored: 0));
                                nameCtl.clear();
                                setState(() {
                                  
                                });
                              }
                            );
                          },
                          child: Container(
                            height: 40, 
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimaryContainer, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  'Create tag',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
    
              }
            },
          ),
        ],
      ),
    );
  }

  void _handleCreateTag({required Function(Color color) onSubmit}) {
    Color pickerColor = Colors.green.shade300;
    showDialog(
      context: context, 
      builder:(context) {
        return AlertDialog(
          title: Text('Create new tag'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                AuthTextfield(hintText: 'Tag name', obscureText: false, controller: nameCtl),
                SizedBox(height: 10,),
                MaterialPicker(pickerColor: pickerColor, onColorChanged: (value) {
                  setState(() {
                    pickerColor = value;
                  });
                })
              ],
            )
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onSubmit(pickerColor);
                },
                child: Text('Create')),
            ElevatedButton(onPressed: () {Navigator.pop(context);}, child: Text('Cancel'))
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameCtl.dispose();

    // scoredCtl.dispose();
    super.dispose();
  }
}
