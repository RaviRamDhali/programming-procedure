import { createSelector } from "reselect";
import { useSelector } from "react-redux";
import { Student } from "Interfaces/student";
import { AppRole } from "Interfaces/user";

// Type the Redux state
interface RootState {
	Student: {
		data: Student;
	};
}

// Base selector
const selectStudentState = (state: RootState) => state.Student;

// Memoized selector
export const selectStudentData = createSelector(selectStudentState, (student) => student.data);

// Hook
const useStudent = () => {
	const data = useSelector(selectStudentData);
	// console.log("retrieved from Redux State:", data);
	return { data };
};

// Hook for student roles
const useStudentRoles = () => {
	const data = useSelector(selectStudentData);

	const isManager = data?.roles?.includes(AppRole.Manager) || false;
	const isStudent = data?.roles?.includes(AppRole.Student) || false;

	return { isManager, isStudent };
};

export { useStudent, useStudentRoles };
