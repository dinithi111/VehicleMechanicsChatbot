import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotService {
  final String apiUrl = 'https://your-api.com/chatbot';
  
  Future<Map<String, dynamic>> sendMessage(
    String message, 
    String language
  ) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': message,
          'language': language,
          'user_id': 'user_123'
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get response');
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Connection error. Using offline mode.'
      };
    }
  }
}