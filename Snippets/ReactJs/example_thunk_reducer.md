## Using Thunk and Reducer

Create folder/files
- \src\slices\course\thunk.ts
- \src\slices\course\reducer.ts

### Component code
```
import { getCoures} from "../../../slices/thunks";
```
```
const dispatch = useDispatch<any>();
useEffect(() => {
		dispatch(getCoures());
	}, []);
```

### thunk.ts code
```
import { getCourseList } from "helpers/ServiceAPI";
import { coursesInit } from "./reducer"

export const getCoures = () => async (dispatch: any) => {
    
    console.log('THUNK getCoures data');

    try {
        let axiosResponse = await getCourseList();

        var response = axiosResponse as any;
        var data = response.value as any;
        console.log('getCoures data', data.value);
        dispatch(coursesInit(data));
        // setCourseList(data.value);
    } catch (error: any) {
        console.error(error);
        // toast.error(error);
    }

    
}
```

### reducer.ts code
```
import { createSlice } from "@reduxjs/toolkit";
import { stat } from "fs";

export const initialState = {
    courses: [],
    course: {},
    error: "", // for error message
    loading: false,
    errorMsg: false, // for error
};

const courseSlice = createSlice({
    name: "course",
    initialState,
    reducers: {
        coursesInit(state, action) {
            console.log("action.payload", action.payload);
            state.courses = action.payload;
            // state.course = {}
            state.loading = false;
            state.errorMsg = false;
        },
        coursesSelected(state, action) {
            console.log("reducer coursesSelected action", action);
            // state.courses = state.courses;
            state.course = action.payload;
            state.loading = false;
            state.errorMsg = false;
        },
    },
});

export const {
    coursesInit,
    coursesSelected,
} = courseSlice.actions;

export default courseSlice.reducer;
```
