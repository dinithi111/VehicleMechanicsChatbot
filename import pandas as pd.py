import pandas as pd
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords

# Load raw data
data = pd.read_csv('vehicle_problems_dataset.csv')

# Text preprocessing
def preprocess_text(text, language='english'):
    # Convert to lowercase
    text = text.lower()
    
    # Tokenization
    tokens = word_tokenize(text)
    
    # Remove stopwords
    stop_words = set(stopwords.words(language))
    filtered_tokens = [w for w in tokens if w not in stop_words]
    
    return ' '.join(filtered_tokens)

# Apply preprocessing
data['processed_query'] = data['user_query'].apply(preprocess_text)
data['processed_solution'] = data['solution'].apply(preprocess_text)