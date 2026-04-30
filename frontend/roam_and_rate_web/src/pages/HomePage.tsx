import React from "react";
import type { User } from "../features/users/types";

interface HomePageProps {
  user: User;
}
const HomePage = ({ user }: HomePageProps) => {
  return (
    <div>
      <div className="banner">Hello {user.fullName}</div>
    </div>
  );
};

export default HomePage;
