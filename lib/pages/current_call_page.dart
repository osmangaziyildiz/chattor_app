// ignore_for_file: use_build_context_synchronously

import 'package:agora_uikit/agora_uikit.dart';
import 'package:chattor_app/configs/agora_config.dart';
import 'package:chattor_app/controller/call_controller.dart';
import 'package:chattor_app/utility/loader_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chattor_app/models/call_model.dart';

class CurrentCallPage extends ConsumerStatefulWidget {
  final String channelId;
  final CallModel call;
  final bool isGroupChat;
  const CurrentCallPage({
    super.key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentCallPageState();
}

class _CurrentCallPageState extends ConsumerState<CurrentCallPage> {
  String baseUrl = 'https://chattor.onrender.com';
  AgoraClient? client;

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await client!.engine.leaveChannel();
                        widget.isGroupChat
                            ? ref.read(callControllerProvider).endGroupCall(
                                context: context,
                                callerId: widget.call.callerId,
                                receiverId: widget.call.receiverId)
                            : ref.read(callControllerProvider).endCall(
                                  context: context,
                                  callerId: widget.call.callerId,
                                  receiverId: widget.call.receiverId,
                                );
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.call_end,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
