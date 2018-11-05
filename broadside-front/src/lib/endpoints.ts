export const serverUrl = (type: "http" | "ws", path: string): string => {
  const domain = process.env.REACT_APP_API;
  const protocol =
    type === "http"
      ? process.env.REACT_APP_API_HTTP_PROTOCOL
      : process.env.REACT_APP_API_WS_PROTOCOL;

  return `${protocol}://${domain}/${path}`;
};
