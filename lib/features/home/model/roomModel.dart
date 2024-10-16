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

  // Factory constructor to create a Room object from a JSON map
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      lastMessage: json['last_message'] as String,
      lastMessageTime: (json['last_message_time'] is int)
          ? DateTime.fromMillisecondsSinceEpoch(json['last_message_time']).toIso8601String()
          : json['last_message_time'] as String,  // Handle case where it's already a string
      members: List<String>.from(json['members'] ?? []),
      createdAt: (json['created_at'] is int)
          ? DateTime.fromMillisecondsSinceEpoch(json['created_at']).toIso8601String()
          : json['created_at'] as String,  // Handle case where it's already a string
    );
  }

  // Method to convert a Room object to a JSON map
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
