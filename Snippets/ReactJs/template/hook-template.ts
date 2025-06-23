import { useSelector } from "react-redux";
import { createSelector } from "reselect";
import { User } from "Interfaces/user";

// Selectors
const selectUser = (state: any) => state.User;

const selectUserData = createSelector(
	selectUser,
	(user) => user.data as User
);

// Hooks
const useUser = () => {
	const user = useSelector(selectUser);
	return { user };
};

const useUserData = () => {
	const user = useSelector(selectUserData);
	return { user };
};

export { useUser, useUserData };
