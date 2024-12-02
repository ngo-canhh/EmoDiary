import 'package:emodiary/provider/user_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String email;

  const ProfileCard({
    super.key,
    this.avatarUrl,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 35,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : AssetImage('lib/assets/images/avatar_none.jpg'),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 16.0),
            // User details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // User email
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await Provider.of<UserState>(context, listen: false).logOut(context: context);
              },
              icon: FaIcon(FontAwesomeIcons.arrowRightFromBracket),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
