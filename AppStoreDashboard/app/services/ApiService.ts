import type { Review, PaginatedReviewsResponse } from '../types/Review';

interface ApiConfig {
  baseUrl: string;
  defaultAppId: string;
}

export class ApiService {
  private config: ApiConfig;

  constructor() {
    this.config = {
      baseUrl: import.meta.env.API_BASE_URL || 'http://localhost:8080',
      defaultAppId: import.meta.env.DEFAULT_APP_ID || '595068606'
    };
  }

  async getReviews(appId?: string, page: number = 1, timeLimit?: number): Promise<PaginatedReviewsResponse> {
    const targetAppId = appId || this.config.defaultAppId;
    let url = `${this.config.baseUrl}/apps/${targetAppId}/reviews?page=${page}`;
    
    if (timeLimit !== undefined) {
      url += `&timeLimit=${timeLimit}`;
    }

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
      
      // Validate that the response has the expected structure
      if (typeof data !== 'object' || data === null) {
        throw new Error('Invalid response format: expected an object');
      }

      if (!Array.isArray(data.items)) {
        throw new Error('Invalid response format: expected items to be an array');
      }

      if (typeof data.metadata !== 'object' || data.metadata === null) {
        throw new Error('Invalid response format: expected metadata object');
      }

      // Validate metadata structure
      const { metadata } = data;
      if (typeof metadata.per !== 'number' || typeof metadata.page !== 'number' || typeof metadata.total !== 'number') {
        throw new Error('Invalid response format: metadata must contain per, page, and total as numbers');
      }

      // Basic validation of review structure
      const validatedReviews: Review[] = data.items.map((item: any, index: number) => {
        if (typeof item !== 'object' || item === null) {
          throw new Error(`Invalid review at index ${index}: not an object`);
        }

        // Validate required fields
        const requiredFields = ['id', 'content', 'author', 'score', 'reviewDate', 'reviewLink'];
        for (const field of requiredFields) {
          if (!(field in item)) {
            throw new Error(`Invalid review at index ${index}: missing required field '${field}'`);
          }
        }

        // Validate types
        if (typeof item.score !== 'number' || item.score < 1 || item.score > 5) {
          throw new Error(`Invalid review at index ${index}: score must be a number between 1 and 5`);
        }

        if (typeof item.id !== 'number') {
          throw new Error(`Invalid review at index ${index}: id must be a number`);
        }

        return {
          id: Number(item.id),
          content: String(item.content),
          author: String(item.author),
          score: Number(item.score),
          reviewDate: String(item.reviewDate),
          reviewLink: String(item.reviewLink)
        };
      });

      return {
        items: validatedReviews,
        metadata: {
          per: metadata.per,
          page: metadata.page,
          total: metadata.total
        }
      };
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
