CREATE TABLE chatbot_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    query_text TEXT NOT NULL,
    response_text TEXT NOT NULL,
    problem_category VARCHAR(50),
    confidence_score DECIMAL(5,2),
    language VARCHAR(20),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE INDEX idx_user_logs ON chatbot_logs(user_id, timestamp);
CREATE INDEX idx_category ON chatbot_logs(problem_category);