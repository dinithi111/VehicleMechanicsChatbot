class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  String _selectedLanguage = 'English';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Mechanic Assistant'),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            items: ['English', 'සිංහල', 'தமிழ்']
                .map((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() => _selectedLanguage = value!);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }
  
  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: _startVoiceInput,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Describe your vehicle problem...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
  
  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    
    String userMessage = _controller.text;
    _controller.clear();
    
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
      ));
    });
    
    // Call chatbot service
    final response = await ChatbotService().sendMessage(
      userMessage,
      _selectedLanguage,
    );
    
    setState(() {
      _messages.add(ChatMessage(
        text: response['response'],
        isUser: false,
        category: response['category'],
      ));
    });
  }
}