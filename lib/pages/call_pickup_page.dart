import 'package:chattor_app/constants/color.dart';
import 'package:chattor_app/controller/call_controller.dart';
import 'package:chattor_app/models/call_model.dart';
import 'package:chattor_app/pages/current_call_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallPickupPage extends ConsumerWidget {
  final Widget scaffold;

  const CallPickupPage({
    super.key,
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: ref.read(callControllerProvider).callStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel callData =
              CallModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          if (!callData.hasDialled) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 50),
                    CircleAvatar(
                      backgroundImage: NetworkImage(callData.callerPic),
                      radius: 60,
                    ),
                    const SizedBox(height: 75),
                    Text(
                      callData.callerName,
                      style: const TextStyle(
                          fontSize: 30,
                          color: MyColor.appBarColor,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 75),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.white12),
                          child: IconButton(
                            color: Colors.black,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return CurrentCallPage(
                                    channelId: callData.callId,
                                    call: callData,
                                    isGroupChat: false,
                                  );
                                },
                              ));
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                              size: 50,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.white12,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.call_end,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
