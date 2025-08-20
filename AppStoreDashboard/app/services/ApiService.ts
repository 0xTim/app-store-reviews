import type { Review } from '../types/Review';

interface ApiConfig {
  baseUrl: string;
  defaultAppId: string;
}

export class ApiService {
  private config: ApiConfig;

  constructor() {
    this.config = {
      baseUrl: import.meta.env.API_BASE_URL || 'http://localhost:3001',
      defaultAppId: import.meta.env.DEFAULT_APP_ID || 'com.example.myapp'
    };
  }

  async getReviews(appId?: string): Promise<Review[]> {
    const targetAppId = appId || this.config.defaultAppId;
    const url = `${this.config.baseUrl}/apps/${targetAppId}/reviews`;

    try {
      const response = await fetch(url, {
        method: 'GET',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status} ${response.statusText}`);
      }

      const data = await response.json();
      
      // Validate that the response is an array
      if (!Array.isArray(data)) {
        throw new Error('Invalid response format: expected an array of reviews');
      }

      // Basic validation of review structure
      const validatedReviews: Review[] = data.map((item, index) => {
        if (typeof item !== 'object' || item === null) {
          throw new Error(`Invalid review at index ${index}: not an object`);
        }

        const review = item as any;
        
        // Validate required fields
        const requiredFields = ['id', 'title', 'content', 'author', 'score', 'date', 'appStoreUrl'];
        for (const field of requiredFields) {
          if (!(field in review)) {
            throw new Error(`Invalid review at index ${index}: missing required field '${field}'`);
          }
        }

        // Validate types
        if (typeof review.score !== 'number' || review.score < 1 || review.score > 5) {
          throw new Error(`Invalid review at index ${index}: score must be a number between 1 and 5`);
        }

        return {
          id: String(review.id),
          title: String(review.title),
          content: String(review.content),
          author: String(review.author),
          score: Number(review.score),
          date: String(review.date),
          appStoreUrl: String(review.appStoreUrl)
        };
      });

      return validatedReviews;
    } catch (error) {
      // Re-throw network/parsing errors with more context
      if (error instanceof TypeError && error.message.includes('fetch')) {
        throw new Error(`Network error: Unable to connect to ${url}. Please check that the API server is running.`);
      }
      
      if (error instanceof SyntaxError) {
        throw new Error('Failed to parse response: The server returned invalid JSON data.');
      }

      // Re-throw our custom validation errors
      throw error;
    }
  }

  getConfig(): ApiConfig {
    return { ...this.config };
  }
}

export const apiService = new ApiService();
