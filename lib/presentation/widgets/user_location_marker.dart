import 'package:flutter/material.dart';

class UserLocationControlWidget extends StatelessWidget {
  final VoidCallback onLocateUser;
  final bool isLoading;

  const UserLocationControlWidget({
    super.key,
    required this.onLocateUser,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'locate_user_fab',
      onPressed: isLoading ? null : onLocateUser,
      tooltip: 'Find My Location',
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.my_location),
    );
  }
}
