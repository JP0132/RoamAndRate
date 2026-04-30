import { useEffect, useState } from "react";
import type { User } from "./features/users/types";
import { getUsers } from "./features/users/userService";
import Logo from "./assets/logo.svg?react";
import Loader from "./common/components/Loader";
import UserPage from "./pages/UserPage";
import HomePage from "./pages/HomePage";

function App() {
  const [usersData, setUsersData] = useState<User[]>([]);
  const [activeUser, setActiveUser] = useState<User | null>(null);
  const [page, setPage] = useState<string>("select");

  const server_url = import.meta.env.VITE_SERVER_URL;

  console.log("Server URL:", server_url);

  const handleUserSelect = (user: User) => {
    setActiveUser(user);
    setPage("home");
  };

  useEffect(() => {
    getUsers().then(setUsersData);
  }, []);

  return (
    <>
      {usersData.length === 0 && (
        <div className="main-container">
          <Logo width={500} height={500} style={{ color: "red" }} />
        </div>
      )}

      {usersData.length != 0 && page === "select" && (
        <UserPage users={usersData} onSelect={handleUserSelect} />
      )}

      {activeUser != null && page === "home" && <HomePage user={activeUser} />}
    </>
  );
}

export default App;
