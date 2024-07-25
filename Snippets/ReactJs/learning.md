# reducer.ts
src\slices\auth\user\reducer.ts \
Reducers handle the synchronous aspects of **state** changes (does not contain business logic)
```
export const initialState = {
    data: {} as User,
    loading: false,
    success: true,
    message: '',
    redirect: '',
};
```

# thunk.ts
src\slices\auth\user\thunk.ts \
Thunks are used to handle asynchronous logic and dispatch actions accordingly (API Calls and Business logic) </br>
"a piece of code that does some delayed work"

# interface vs class
**Use "interface" to define an object** (javascript POJO Plain old Javascripy Object)\
Avoid using "class" > Define an object wtih attached logic (no javascript friendly)\
Classes are not a TypeScript feature\
Classes are a JavaScript feature. Nothing about classes is specific to TypeScript. TypeScript only adds type information in your editor, but it doesn't add features to your programming language - you are programming in JavaScript.\
JavaScript has classes class Foo {}; new Foo, arrays [1,2,3] and objects { foo: "bar" }.\
If you want to store data, use an object or an array. If you want data with attached logic, use a class.\
Storing data without attached logic in a class is a misuse of features of your programming language - this has nothing to do with Redux and everything with learning the programming language you are using.\

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
