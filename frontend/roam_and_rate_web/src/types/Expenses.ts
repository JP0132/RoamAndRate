export type Expense = {
    id: string,
    tripId: string,
    name: string,
    cost: number,
    currency: string,
    paid: boolean,
    dateAdded: Date,
    datePaid: Date,
    category: string,
    type: string,
    tags: string[],
}