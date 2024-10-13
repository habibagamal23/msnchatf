class Room {
  String id;
  String lastMessage;
  String lastMessageTime;
  List<String> members;
  String createdAt;

  Room({
    required this.id,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.members,
    required this.createdAt,
  });

  // Create a Room object from Firestore JSON data
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      lastMessage: json['last_message'] as String,
      lastMessageTime: json['last_message_time'] as String,
      members: List<String>.from(json['members']),
      createdAt: json['created_at'] as String,
    );
  }

  // Convert Room object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'members': members,
      'created_at': createdAt,
    };
  }
}
