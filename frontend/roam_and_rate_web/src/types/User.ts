import type { Participant } from "./Participant"

export type User = {
    username: string,
    fullName: string,
    dob: string,
    gender: string,
    admin: boolean,
    lastUpdated: string,
    id: string,
    createdAt: string
    participant: Participant[]
}