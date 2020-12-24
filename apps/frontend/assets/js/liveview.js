import { Socket } from "phoenix";

import LiveSocket from "phoenix_live_view";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.__x) {
        window.Alpine.clone(from.__x, to);
      }
    },
  },
  params: {
    _csrf_token: csrfToken,
  },
});
liveSocket.connect();

console.log("HELLO");

export default liveSocket;
