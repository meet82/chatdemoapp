
class Message {
  final String from;
  final String to;
  final String message;

  Message({required this.from, required this.to, required this.message});

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'message': message,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      from: map['from'],
      to: map['to'],
      message: map['message'],
    );
  }
}
