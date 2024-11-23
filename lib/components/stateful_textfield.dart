import 'package:emodiary/components/auth_textfield.dart';
import 'package:flutter/material.dart';

class StatefulTextfield extends StatefulWidget {
  const StatefulTextfield({super.key, required this.fields, this.onSubmit, this.obscureText});
  final List<String> fields;
  final Function(Map<String, TextEditingController>, List<String>)? onSubmit;
  final bool? obscureText;

  @override
  State<StatefulTextfield> createState() => _StatefulTextfieldState();
}

class _StatefulTextfieldState extends State<StatefulTextfield> {
  final authTextfields = <Widget>[];
  Map<String, TextEditingController> controllers = {};
  late List<String> fields;

  @override
  void initState() {
    super.initState();
    fields = widget.fields;

    for (var field in fields) {
      controllers[field] = TextEditingController();
      authTextfields.add(SizedBox(height: 8,));
      authTextfields.add(AuthTextfield(
          hintText: field,
          obscureText: widget.obscureText ?? false,
          controller: controllers[field]!));
    }
  }
  @override
  void dispose() {
    for (var pair in controllers.entries) {
      pair.value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Center(
        child: Column(
          children: [
            ...authTextfields,
            SizedBox(
              height: 20,
            ),
            if (widget.onSubmit != null)
              
            ElevatedButton(
                onPressed: () {
                  widget.onSubmit!(controllers, fields);
                },
                child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}
