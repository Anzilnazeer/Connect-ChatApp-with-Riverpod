import 'package:connect_riverpod/model/status_model.dart';
import 'package:connect_riverpod/screens/status/controller/status_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 215, 247, 253),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.w),
          topRight: Radius.circular(30.w),
        ),
      ),
      child: FutureBuilder<List<Status>>(
        future: ref.read(statusControllerProvider).getStatus(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle the case when there's no data to display.
            return const Center(child: Text('No stories available'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var statusData = snapshot.data![index];
              return Card(
                color: const Color.fromARGB(34, 255, 255, 255),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: ListTile(
                  onTap: () {
                    // Handle the tap action.
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(statusData.profilePic),
                    radius: 25.w,
                  ),
                  title: Text(statusData.userName),
                  subtitle: Text(
                    statusData.createdAt as String,
                    maxLines: 1,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
