import type { User } from "./User";

export type Trip = {
    id: string;
    userId: string;
    tripName: string;
    location: string;
    currency: string;
    category: string;
    budget: number;
    notes: string;
    images: string;
    bgColour: string;
    startDate: string;
    endDate: string;
    createdAt: string;
    lastUpdated: string;
}