import { Socket } from "phoenix";

import { LiveSocket } from "phoenix_live_view";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
      }
    },
  },
  params: {
    _csrf_token: csrfToken,
  },
});
liveSocket.connect();

console.log("HELLO");

window.liveSocket = liveSocket;

export default liveSocket;
