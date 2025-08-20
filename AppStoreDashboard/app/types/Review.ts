export interface Review {
  id: number;
  title: string;
  content: string;
  score: number; // 1-5 stars
  reviewDate: string; // ISO date string
  author: string;
  reviewLink: string;
}

export interface PaginationMetadata {
  per: number;
  page: number;
  total: number;
}

export interface PaginatedReviewsResponse {
  items: Review[];
  metadata: PaginationMetadata;
}
