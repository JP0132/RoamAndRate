import type { Participant } from "../participants/types";
import type { Trip } from "../trips/types";

export type User = {
  id: string;
  username: string;
  fullName: string;
  dob: string;
  gender: string;
  admin: boolean;
  lastUpdated: string;
  createdAt: string;
  participants: Participant[];
  trips: Trip[];
};
