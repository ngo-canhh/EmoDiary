import 'package:emodiary/provider/user_state.dart';
import 'package:emodiary/views/note/create_or_edit_note.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  TextEditingController titleController = TextEditingController();
  String thoughtfulMessage = 'How are you today!';

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context).user!;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3), // màu viền nhạt
          width: 1.5, // độ dày viền
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(-2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề ngày
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, d MMMM yyyy', 'en_US').format(DateTime.now()),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Nội dung chính
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh với viền gradient
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.onPrimaryContainer, theme.colorScheme.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding:
                    const EdgeInsets.all(1), // khoảng cách gradient và avatar
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : const AssetImage('lib/assets/images/avatar_none.jpg')
                          as ImageProvider,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(width: 16),
              // Lời chào và nội dung
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello ${user.displayName ?? 'user'},',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      thoughtfulMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: titleController,
                          decoration:
                              InputDecoration(hintText: 'Write something ...', hintStyle: TextStyle(fontSize: 14, color: theme.textTheme.bodySmall?.color?.withOpacity(0.6))),
                        )),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            final title = titleController.text;
                            titleController.clear();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateOrEditNote(title: title,)));
                          },
                          icon: const FaIcon(FontAwesomeIcons.notesMedical),
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
