import type { Route } from "./+types/home";
import { AppStoreDashboard } from "../components/AppStoreDashboard";

export function meta({}: Route.MetaArgs) {
  return [
    { title: "App Store Reviews Dashboard" },
    { name: "description", content: "Dashboard displaying App Store reviews and ratings" },
  ];
}

export default function Home() {
  return <AppStoreDashboard />;
}
