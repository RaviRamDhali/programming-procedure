## State object are lost on browser refresh
Losing state on browser refresh is a common issue when using Redux. To address this, you can use the redux-persist library, which allows you to save the Redux state to local storage or another storage engine.

## Step 1 - Update root index.tsx middleware with redux-persist
{project}\WebApp\ClientApp\src\index.tsx
```
import React, { StrictMode } from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import reportWebVitals from './reportWebVitals';
import { BrowserRouter } from "react-router-dom";
import { Provider } from "react-redux";
import { configureStore } from "@reduxjs/toolkit";
import rootReducer from "./slices";
import { FLUSH, PAUSE, PERSIST, PURGE, REGISTER, REHYDRATE, persistStore } from 'redux-persist';
import { PersistGate } from 'redux-persist/integration/react';
import './index.css';


const store = configureStore({
  reducer: rootReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: [FLUSH, PAUSE, PERSIST, PURGE, REGISTER],
      },
    }),
  devTools: true,
});
const persistor = persistStore(store);

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <Provider store={store}>
    <PersistGate loading={null} persistor={persistor}>
      <React.Fragment>
        <BrowserRouter basename={process.env.PUBLIC_URL}>
          <StrictMode>
            <App />
          </StrictMode>
        </BrowserRouter>
      </React.Fragment>
    </PersistGate>
  </Provider>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
```

## Step 2 - Update slice index.ts storage and redux-persist
{project}\ClientApp\src\slices\index.ts

```
const persistConfigTenant = { key: 'tenant', storage, };
const persistConfigToken = { key: 'token', storage, };
```
then 
```
const rootReducer = combineReducers({

    Account: AccountReducer,
    Login: LoginReducer,
    Layout: LayoutReducer,
    DashboardProject: DashboardProjectReducer,

    Tenant: persistReducer(persistConfigTenant, TenantReducer),
    Token: persistReducer(persistConfigToken, TokenReducer),
......................
})
