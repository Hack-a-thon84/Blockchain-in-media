import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import TfidfVectorizer

# Sample user interactions dataset
data = {
    'user_id': [1, 1, 1, 2, 2, 3, 3],
    'content_id': [101, 102, 103, 101, 104, 102, 103],
    'interaction_type': ['view', 'like', 'purchase', 'view', 'like', 'view', 'purchase']
}

df = pd.DataFrame(data)

# TF-IDF for content similarity (if it's content-based recommendation)
content_data = {
    'content_id': [101, 102, 103, 104],
    'description': ["AI-driven content", "Blockchain for media", "NFT art collection", "Decentralized marketplace"]
}

content_df = pd.DataFrame(content_data)

# Vectorize the content descriptions
tfidf_vectorizer = TfidfVectorizer()
tfidf_matrix = tfidf_vectorizer.fit_transform(content_df['description'])

# Calculate cosine similarity between content items
content_similarity = cosine_similarity(tfidf_matrix)

# Recommendation function based on content similarity
def recommend_content(user_id, num_recommendations=3):
    # Get the content the user has interacted with
    user_interactions = df[df['user_id'] == user_id]['content_id']
    
    # Find similar content for the user
    recommendations = []
    for content_id in user_interactions:
        content_index = content_df[content_df['content_id'] == content_id].index[0]
        similar_content = list(enumerate(content_similarity[content_index]))
        similar_content = sorted(similar_content, key=lambda x: x[1], reverse=True)[1:num_recommendations+1]
        
        for item in similar_content:
            recommendations.append(content_df.iloc[item[0]]['content_id'])
    
    return set(recommendations)  # Return unique recommendations

# Example usage
print(recommend_content(1))  # Recommend for user 1
