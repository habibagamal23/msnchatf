class Message {
  String id;
  String toId;
  String fromId;
  String msg;
  bool read;
  String createdAt;
  String type;

  Message({
    required this.id,
    required this.toId,
    required this.fromId,
    required this.msg,
    required this.read,
    required this.createdAt,
    required this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      toId: json['to_id'],
      fromId: json['from_id'],
      msg: json['msg'],
      read: json['read'],
      createdAt: json['created_at'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'to_id': toId,
      'from_id': fromId,
      'msg': msg,
      'read': read,
      'created_at': createdAt,
      'type': type,
    };
  }
}
