// ignore_for_file: public_member_api_docs, sort_constructors_first

class Group {
  final String senderId;
  final String name;
  final String groupUid;
  final String lastMessage;
  final DateTime timeSent;
  final String groupPic;
  final List<String> membersUid;

  Group({
    required this.timeSent,
    required this.senderId,
    required this.name,
    required this.groupUid,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'name': name,
      'groupUid': groupUid,
      'lastMessage': lastMessage,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'groupPic': groupPic,
      'membersUid': membersUid,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      senderId: map['senderId'] as String,
      name: map['name'] as String,
      groupUid: map['groupUid'] as String,
      lastMessage: map['lastMessage'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      groupPic: map['groupPic'] as String,
      membersUid: List<String>.from(map['membersUid']),
    );
  }
}
