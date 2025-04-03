import 'package:cardx/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(
      userDetailsProvider(
        ref.watch(currentUserAccountProvider).value!.$id,
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  user.value?.profilePic != null
                      ? NetworkImage(user.value!.profilePic)
                          as ImageProvider
                      : const AssetImage(
                        'assets/images/default_profile.png',
                      ),
            ),
            const SizedBox(height: 12),
            const Text(
              'John Doe', // Replace with dynamic user name
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '3D Generalist at Blender Studio', // Replace with user details
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
