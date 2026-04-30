import axios from "axios";
import type { User } from "./types";

const server_url = import.meta.env.VITE_SERVER_URL;

export const getUsers = async (): Promise<User[]> => {
  const response = await axios.get<{ users: User[] }>(
    `${server_url}/getUsersData`,
  );
  return response.data.users;
};
