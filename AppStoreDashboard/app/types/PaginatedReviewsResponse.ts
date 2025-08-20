import type { Review } from './Review';
import type { PaginationMetadata } from './PaginationMetadata';

export interface PaginatedReviewsResponse {
  items: Review[];
  metadata: PaginationMetadata;
}
