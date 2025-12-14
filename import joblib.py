import joblib
import requests
from datetime import datetime

class VehicleChatbot:
    def __init__(self):
        self.classifier = joblib.load('models/intent_classifier.pkl')
        self.vectorizer = joblib.load('models/tfidf_vectorizer.pkl')
        self.openai_key = "YOUR_API_KEY"
        
    def classify_intent(self, user_query):
        """Classify user query into problem category"""
        processed = self.preprocess_text(user_query)
        features = self.vectorizer.transform([processed])
        category = self.classifier.predict(features)[0]
        confidence = max(self.classifier.predict_proba(features)[0])
        return category, confidence
    
    def get_response(self, user_query, language='english'):
        """Generate chatbot response"""
        # Step 1: Classify intent
        category, confidence = self.classify_intent(user_query)
        
        # Step 2: Generate response
        if confidence > 0.75:
            # Use ML model + template response
            response = self.get_template_response(category)
        else:
            # Use OpenAI for complex queries
            response = self.get_ai_response(user_query, language)
        
        # Step 3: Translate if needed
        if language != 'english':
            response = self.translate(response, language)
        
        return {
            'category': category,
            'response': response,
            'confidence': confidence,
            'timestamp': datetime.now().isoformat()
        }
    
    def get_ai_response(self, query, language):
        """Call OpenAI API for complex queries"""
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.openai_key}"
        }
        
        prompt = f"""You are an expert vehicle mechanic assistant. 
        Provide a clear, step-by-step solution for: {query}
        Language: {language}
        Keep response under 150 words."""
        
        payload = {
            "model": "gpt-3.5-turbo",
            "messages": [
                {"role": "system", "content": "Vehicle diagnostic assistant"},
                {"role": "user", "content": prompt}
            ],
            "max_tokens": 200
        }
        
        response = requests.post(
            "https://api.openai.com/v1/chat/completions",
            headers=headers,
            json=payload
        )
        
        return response.json()['choices'][0]['message']['content']