import * as React from "react";
import Map from "./game/Map";

import styled from "./styled-components";
import { injectGlobal } from "./styled-components";

class App extends React.Component {
  render() {
    return (
      <AppStyled>
        <Map />
      </AppStyled>
    );
  }
}

const AppStyled = styled.div`
  height: 100%;
  width: 100%;
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
`;

export default App;
