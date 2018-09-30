import * as React from "react";
import * as ReactDOM from "react-dom";
import { Provider } from "react-redux";
import { createStore, applyMiddleware } from "redux";
import { composeWithDevTools } from "redux-devtools-extension";

import App from "./App";
import rootReducer from "./reducers";
import registerServiceWorker from "./registerServiceWorker";
import redexMiddleware from "./redex/redex-middleware";

const composeEnhancers = composeWithDevTools({});

const middleware = [
  redexMiddleware({
    socketEndpoint: "ws://localhost:4000/socket",
    tokenEndpoint: "http://localhost:4000/api/users"
  })
];

const store = createStore(
  rootReducer,
  composeEnhancers(applyMiddleware(...middleware))
);

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById("root")
);
registerServiceWorker();
