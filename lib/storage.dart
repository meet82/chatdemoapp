import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'user.dart';
import 'message.dart';

class Storage {
  Future<bool> registerUser(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? users = prefs.getStringList('users');

    if (users == null) {
      users = [];
    }

    for (String user in users) {
      Map<String, dynamic> userMap = json.decode(user);
      if (userMap['username'] == username) {
        return false; // User already exists
      }
    }

    User newUser = User(username: username, password: password);
    users.add(json.encode(newUser.toMap()));
    await prefs.setStringList('users', users);
    return true;
  }

  Future<bool> loginUser(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? users = prefs.getStringList('users');

    if (users == null) {
      return false;
    }

    for (String user in users) {
      Map<String, dynamic> userMap = json.decode(user);
      if (userMap['username'] == username && userMap['password'] == password) {
        return true; // User found
      }
    }

    return false;
  }

  Future<void> sendMessage(String from, String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? messages = prefs.getStringList('messages');

    if (messages == null) {
      messages = [];
    }

    List<String>? users = prefs.getStringList('users');
    if (users != null) {
      for (String user in users) {
        Map<String, dynamic> userMap = json.decode(user);
        if (userMap['username'] != from) {
          Message newMessage = Message(from: from, to: userMap['username'], message: message);
          messages.add(json.encode(newMessage.toMap()));
        }
      }
    }

    await prefs.setStringList('messages', messages);
  }

  Future<List<Map<String, String>>> getMessages(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? messages = prefs.getStringList('messages');

    if (messages == null) {
      return [];
    }

    List<Map<String, String>> userMessages = [];
    for (String message in messages) {
      Map<String, dynamic> messageMap = json.decode(message);
      if (messageMap['to'] == username || messageMap['from'] == username) {
        userMessages.add({
          'from': messageMap['from'],
          'to': messageMap['to'],
          'message': messageMap['message'],
        });
      }
    }

    return userMessages;
  }
}
