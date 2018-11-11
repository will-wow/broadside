import styled from "../styled-components";
import * as Colors from "./colors";

import { darken } from "polished";

export const Button = styled.button`
  background: ${Colors.paper};
  color: ${Colors.pencil};
  font-size: 1rem;
  padding: 0.5rem 1rem;
  border: 1px solid ${Colors.pencil};

  &:hover {
    background: ${darken(0.1, Colors.paper)};
  }
`;
