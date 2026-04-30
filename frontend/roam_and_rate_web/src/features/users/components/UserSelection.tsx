import type { User } from "../types";
interface UserSelectionProps {
  users: User[];
}

const UserSelection = ({ users }: UserSelectionProps) => {
  return (
    <div className="flex flex-col">
      {users.map((user: User, i: number) => {
        return (
          <div key={user.id}>
            <UserSelectionCard user={user} />
          </div>
        );
      })}
    </div>
  );
};

const UserSelectionCard = ({ user }: { user: User }) => {
  return (
    <div className="w-full p-2">
      <h1>{user.username}</h1>
    </div>
  );
};

export default UserSelection;
