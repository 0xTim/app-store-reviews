import { useState, useEffect } from 'react';
import type { Review, PaginationMetadata } from '../types/Review';
import { apiService } from '../services/ApiService';

interface UseReviewsResult {
  reviews: Review[];
  loading: boolean;
  loadingMore: boolean;
  error: string | null;
  metadata: PaginationMetadata | null;
  refetch: () => Promise<void>;
  loadMore: () => Promise<void>;
  hasMore: boolean;
}

export function useReviews(appId?: string): UseReviewsResult {
  const [reviews, setReviews] = useState<Review[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [metadata, setMetadata] = useState<PaginationMetadata | null>(null);
  const [currentPage, setCurrentPage] = useState(1);

  const fetchReviews = async (page: number = 1, append: boolean = false) => {
    try {
      if (page === 1) {
        setLoading(true);
      } else {
        setLoadingMore(true);
      }
      setError(null);
      
      const data = await apiService.getReviews(appId, page);
      
      if (append) {
        setReviews(prev => [...prev, ...data.items]);
      } else {
        setReviews(data.items);
      }
      
      setMetadata(data.metadata);
      setCurrentPage(page);
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'An unexpected error occurred';
      setError(errorMessage);
      console.error('Failed to fetch reviews:', err);
    } finally {
      setLoading(false);
      setLoadingMore(false);
    }
  };

  const loadMore = async () => {
    if (metadata && currentPage * metadata.per < metadata.total) {
      await fetchReviews(currentPage + 1, true);
    }
  };

  const refetch = async () => {
    setCurrentPage(1);
    await fetchReviews(1, false);
  };

  useEffect(() => {
    fetchReviews();
  }, [appId]);

  const hasMore = metadata ? currentPage * metadata.per < metadata.total : false;

  return {
    reviews,
    loading,
    loadingMore,
    error,
    metadata,
    refetch,
    loadMore,
    hasMore
  };
}
