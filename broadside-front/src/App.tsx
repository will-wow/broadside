import * as React from "react";

import styled from "./styled-components";
import { injectGlobal } from "./styled-components";

import { connect } from "react-redux";
import { Store } from "./reducers";
import { route } from "./route-selectors";

interface AppProps {
  route: any;
}

class App extends React.Component<AppProps> {
  render() {
    const { route: Route } = this.props;
    return (
      <AppStyled>
        <Route />
      </AppStyled>
    );
  }
}

const AppStyled = styled.div`
  height: 100%;
  width: 100%;
  font-family: sans-serif;
`;

// tslint:disable:no-unused-expression
injectGlobal`
  body, html {
    height: 100%;
    width: 100%;
  }
  body {
    margin: 0;
  }
  * {
    box-sizing: border-box;
  }
`;

export const mapStateToProps = (state: Store) => {
  return {
    route: route(state)
  };
};

const connectedComponent = connect(mapStateToProps)(App);

export default connectedComponent;

export { App };
