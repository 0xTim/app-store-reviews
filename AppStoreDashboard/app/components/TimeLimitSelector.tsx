export interface TimeLimitOption {
  value: number; // seconds
  label: string;
  description: string;
}

export const TIME_LIMIT_OPTIONS: TimeLimitOption[] = [
  {
    value: 48 * 60 * 60, // 48 hours in seconds
    label: '48 hours',
    description: 'Reviews from the last 2 days'
  },
  {
    value: 3 * 24 * 60 * 60, // 3 days in seconds
    label: '3 days',
    description: 'Reviews from the last 3 days'
  },
  {
    value: 5 * 24 * 60 * 60, // 5 days in seconds
    label: '5 days',
    description: 'Reviews from the last 5 days'
  },
  {
    value: 7 * 24 * 60 * 60, // 1 week in seconds
    label: '1 week',
    description: 'Reviews from the last week'
  },
  {
    value: 30 * 24 * 60 * 60, // 1 month in seconds
    label: '1 month',
    description: 'Reviews from the last month'
  },
  {
    value: 6 * 30 * 24 * 60 * 60, // 6 months in seconds (approximately)
    label: '6 months',
    description: 'Reviews from the last 6 months'
  }
];

interface TimeLimitSelectorProps {
  selectedTimeLimit: number;
  onTimeLimitChange: (timeLimit: number) => void;
  disabled?: boolean;
}

export function TimeLimitSelector({ 
  selectedTimeLimit, 
  onTimeLimitChange, 
  disabled = false 
}: TimeLimitSelectorProps) {
  return (
    <div className="mb-6">
      <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">
        <svg className="w-4 h-4 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        Time Range
      </label>
      <div className="relative">
        <select
          value={selectedTimeLimit}
          onChange={(e) => onTimeLimitChange(Number(e.target.value))}
          disabled={disabled}
          className="block w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 disabled:bg-gray-100 dark:disabled:bg-gray-700 disabled:cursor-not-allowed"
        >
          {TIME_LIMIT_OPTIONS.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label} - {option.description}
            </option>
          ))}
        </select>
        <div className="absolute inset-y-0 right-0 flex items-center px-2 pointer-events-none">
          <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
          </svg>
        </div>
      </div>
    </div>
  );
}
