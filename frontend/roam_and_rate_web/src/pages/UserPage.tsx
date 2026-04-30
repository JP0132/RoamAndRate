import React, { useState } from "react";
import Logo from "../assets/logo.svg?react";
import type { User } from "../features/users/types";
import UserSelectionCard from "../features/users/components/UserSelectionCard";

interface UserPageProps {
  users: User[];
  onSelect: (user: User) => void;
}

const UserPage = ({ users, onSelect }: UserPageProps) => {
  const [hover, setHover] = useState<string | null>(null);
  const [selected, setSelected] = useState<string | null>(null);

  const handlePick = (user: User) => {
    if (selected) return;
    setSelected(user.id);
    setTimeout(() => onSelect(user), 600);
  };

  return (
    <div className="main-container">
      <Logo width={100} height={100} />
      <h1>Who's roaming?</h1>
      <h3>Choose your profile...</h3>
      <div className="divider-container">
        <div className="divider" />
        <span className="divider-text">{users.length} profiles</span>
        <div className="divider" />
      </div>

      <div className="user-grid">
        {users.map((user, i) => {
          const isHov = hover === user.id;
          const isSel = selected === user.id;
          const isDim = selected && !isSel;

          return (
            <div
              key={user.id}
              className={`
          usr-card
          ${isSel ? "selected" : "default"}
          ${isHov ? "hover" : ""}
          ${isDim ? "dim" : ""}
        `}
              onClick={() => handlePick(user)}
              onMouseEnter={() => setHover(user.id)}
              onMouseLeave={() => setHover(null)}
              style={{
                border: `1px solid ${
                  isSel
                    ? "var(--secondary-text)"
                    : isHov
                      ? "var(--primary)"
                      : "var(--secondary-text)"
                }`,
                animation: `usrFadeUp 0.5s cubic-bezier(.34,1.2,.64,1) ${
                  i * 0.08
                }s both`,
              }}
            >
              <div className="card-shine" />

              <div
                className="avatar"
                style={{
                  background: `linear-gradient(145deg, var(--primary), var(--secondary))`,
                }}
              >
                <span style={{ color: "var(--background)" }}>
                  {user.fullName}
                </span>
              </div>

              <div style={{ width: "100%" }}>
                <p className="user-name">{user.fullName.split(" ")[0]}</p>

                <div className="stats">
                  <div className="stat">
                    <p>{user.trips.length}</p>
                    <p>Trips</p>
                  </div>

                  <div
                    className="stat-divider"
                    style={{ background: "var(--primary)" }}
                  />

                  <div className="stat">
                    <p>{user.gender}</p>
                    <p>Gender</p>
                  </div>
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* <div className="selection-grid">
        {users.map((user: User, i: number) => {
          return (
            <div key={user.id}>
              <UserSelectionCard user={user} />
            </div>
          );
        })}
      </div> */}
    </div>
  );
};

export default UserPage;
