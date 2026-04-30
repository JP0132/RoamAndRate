import React, { useState } from "react";
import type { User } from "../types";

interface UserSelectionCardProps {
  user: User;
}
const UserSelectionCard = ({ user }: { user: User }) => {
  return (
    <div className="user-card">
      <div style={{ position: "relative" }}>
        <>
          <div className="avatar-1" />
          <div className="avatar-2" />
        </>
      </div>
      <h1>{user.username}</h1>
    </div>
  );
};

export default UserSelectionCard;
