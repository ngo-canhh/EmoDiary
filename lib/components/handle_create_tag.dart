import 'package:emodiary/components/auth_textfield.dart';
import 'package:emodiary/database/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void handleCreateTag(
    {Tag? tag,
    required BuildContext context,
    required TextEditingController tagNameController,
    required Function(Tag newTag) onSubmit}) {
  Tag newTag =
      tag ?? Tag(name: '', scored: 5, color: Colors.green.shade300.value);
  tagNameController.text = newTag.name;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: tag == null ? Text('Create new tag') : Text('Edit tag'),
        content: SingleChildScrollView(
            child: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            children: [
              AuthTextfield(
                  hintText: 'Tag name',
                  obscureText: false,
                  controller: tagNameController),
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
                            pickerColor: Color(newTag.color!),
                            onColorChanged: (color) {
                              setDialogState(() {
                                newTag.color = color.value;
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
                                  color: newTag.scored == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              selected: newTag.scored == index,
                              selectedColor: Color(newTag.color!),
                              onSelected: (isSelected) {
                                // if (!isSelected) {
                                setDialogState(() {
                                  newTag.scored = index;
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
                newTag.name = tagNameController.text;

                onSubmit(newTag);
              },
              child: Text('Save')),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'))
        ],
      );
    },
  ).then((_) {
    tagNameController.clear();
  });
}
