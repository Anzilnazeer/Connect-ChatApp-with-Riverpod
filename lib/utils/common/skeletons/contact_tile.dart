import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContactSkeleton extends StatelessWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;

  const ContactSkeleton({
    required this.isCircularImage,
    required this.isBottomLinesActive,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(70, 255, 255, 255),
      highlightColor: Color.fromARGB(255, 212, 235, 255),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isCircularImage)
                CircleAvatar(
                  radius: 32.0,
                  backgroundColor: Colors.grey[300],
                )
              else
                Container(
                  width: 48.0,
                  height: 48.0,
                  color: Colors.grey[300],
                ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16.0,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8.0),
                    if (isBottomLinesActive)
                      Container(
                        width: double.infinity,
                        height: 12.0,
                        color: Colors.grey[300],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
