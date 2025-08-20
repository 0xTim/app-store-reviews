export interface Review {
  id: string;
  title: string;
  content: string;
  author: string;
  score: number; // 1-5 stars
  date: string;
  appStoreUrl: string;
}
