import { ReviewCard } from '../components/ReviewCard';
import { LoadingSpinner, LoadingCard } from '../components/LoadingSpinner';
import { ErrorMessage } from '../components/ErrorMessage';
import { LoadMoreButton } from '../components/LoadMoreButton';
import { TimeLimitSelector, TIME_LIMIT_OPTIONS } from '../components/TimeLimitSelector';
import { useReviews } from '../hooks/useReviews';
import { useState } from 'react';

export function AppStoreDashboard() {
  const [selectedTimeLimit, setSelectedTimeLimit] = useState(TIME_LIMIT_OPTIONS[0].value); // Default to 48 hours
  const { reviews, loading, loadingMore, error, metadata, refetch, loadMore, hasMore, updateTimeLimit } = useReviews(undefined, selectedTimeLimit);

  const handleTimeLimitChange = async (newTimeLimit: number) => {
    setSelectedTimeLimit(newTimeLimit);
    await updateTimeLimit(newTimeLimit);
  };

  if (error) {
    return <ErrorMessage error={error} onRetry={refetch} />;
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
        <div className="container mx-auto px-4 py-8">
          <div className="mb-8">
            <h1 className="text-4xl font-bold text-gray-900 dark:text-white mb-4">
              App Store Reviews Dashboard
            </h1>
            <div className="flex flex-col sm:flex-row gap-6 p-6 bg-white dark:bg-gray-800 rounded-lg shadow-md border border-gray-200 dark:border-gray-700 animate-pulse">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 bg-gray-300 dark:bg-gray-600 rounded-full"></div>
                <div>
                  <div className="h-8 w-16 bg-gray-300 dark:bg-gray-600 rounded mb-1"></div>
                  <div className="h-4 w-24 bg-gray-300 dark:bg-gray-600 rounded"></div>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 bg-gray-300 dark:bg-gray-600 rounded-full"></div>
                <div>
                  <div className="h-8 w-16 bg-gray-300 dark:bg-gray-600 rounded mb-1"></div>
                  <div className="h-4 w-24 bg-gray-300 dark:bg-gray-600 rounded"></div>
                </div>
              </div>
            </div>
          </div>
          
          {/* Time Limit Selector Skeleton */}
          <div className="mb-8">
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md border border-gray-200 dark:border-gray-700 p-6 animate-pulse">
              <div className="h-4 w-20 bg-gray-300 dark:bg-gray-600 rounded mb-3"></div>
              <div className="h-10 w-full bg-gray-300 dark:bg-gray-600 rounded"></div>
            </div>
          </div>
          
          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-1 xl:grid-cols-2">
            {[...Array(6)].map((_, i) => (
              <LoadingCard key={i} />
            ))}
          </div>
        </div>
      </div>
    );
  }

  const totalReviews = metadata?.total || 0;
  const loadedReviews = reviews.length;

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 dark:text-white mb-4">
            App Store Reviews Dashboard
          </h1>
          <div className="flex flex-col sm:flex-row gap-6 p-6 bg-white dark:bg-gray-800 rounded-lg shadow-md border border-gray-200 dark:border-gray-700">
            <div className="flex items-center gap-3">
              <div className="p-3 bg-green-100 dark:bg-green-900 rounded-full">
                <svg className="w-6 h-6 text-green-600 dark:text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
              </div>
              <div>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">
                  {totalReviews}
                </p>
                <p className="text-sm text-gray-600 dark:text-gray-400">
                  Total Reviews
                </p>
              </div>
            </div>
            {totalReviews > loadedReviews && (
              <div className="flex items-center gap-3">
                <div className="p-3 bg-orange-100 dark:bg-orange-900 rounded-full">
                  <svg className="w-6 h-6 text-orange-600 dark:text-orange-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                </div>
                <div>
                  <p className="text-2xl font-bold text-gray-900 dark:text-white">
                    {loadedReviews}
                  </p>
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    Showing
                  </p>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Time Limit Selector */}
        <div className="mb-8">
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md border border-gray-200 dark:border-gray-700 p-6">
            <TimeLimitSelector
              selectedTimeLimit={selectedTimeLimit}
              onTimeLimitChange={handleTimeLimitChange}
              disabled={loading || loadingMore}
            />
          </div>
        </div>

        {/* Reviews Grid */}
        {reviews.length === 0 ? (
          <div className="text-center py-12">
            <div className="mx-auto flex items-center justify-center w-16 h-16 bg-gray-100 dark:bg-gray-800 rounded-full mb-4">
              <svg className="w-8 h-8 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            </div>
            <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-2">
              No Reviews Found
            </h3>
            <p className="text-gray-600 dark:text-gray-400">
              There are currently no reviews available for this app.
            </p>
          </div>
        ) : (
          <>
            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-1 xl:grid-cols-2">
              {reviews.map((review) => (
                <ReviewCard key={review.id} review={review} />
              ))}
            </div>
            
            {/* Load More Section */}
            {hasMore && (
              <LoadMoreButton
                onLoadMore={loadMore}
                loading={loadingMore}
                disabled={loadingMore}
              />
            )}
            
            {/* Loading More Cards */}
            {loadingMore && (
              <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-1 xl:grid-cols-2 mt-6">
                {[...Array(4)].map((_, i) => (
                  <LoadingCard key={`loading-${i}`} />
                ))}
              </div>
            )}
            
            {/* Pagination Info */}
            {metadata && (
              <div className="text-center mt-6 text-sm text-gray-600 dark:text-gray-400">
                Showing {loadedReviews} of {totalReviews} reviews
                {metadata.per && (
                  <span className="ml-2">
                    ({metadata.per} per page)
                  </span>
                )}
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}
