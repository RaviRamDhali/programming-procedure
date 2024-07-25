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


