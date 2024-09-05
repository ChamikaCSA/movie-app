import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/services/auth_service.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    super.key,
    required this.imageUrl,
    required this.displayName,
  });

  final String? imageUrl;
  final String? displayName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: const EdgeInsets.all(10),
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            CircleAvatar(
              radius: 30,
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(imageUrl!),
                    )
                  : const Icon(CupertinoIcons.person),
            ),
            const SizedBox(width: 10),
            Text(displayName ?? '',
                style: Theme.of(context).textTheme.titleLarge),
          ]),
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.profile_circled),
          title: const Text('Profile'),
          subtitle: const Text('View your profile'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          subtitle: const Text('Sign out of your account'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: AuthService().signOut,
        ),
      ],
    ));
  }
}
