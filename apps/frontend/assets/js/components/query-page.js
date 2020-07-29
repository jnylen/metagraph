import hljs from "highlight.js";
import json from "highlight.js/lib/languages/json";

hljs.registerLanguage("json", json);

import { removeClass } from "@kollegorna/js-utils/src/attribute";

const queryPage = () => {
  return {
    textInput: "",
    run: async function () {
      const csrfToken = document.head.querySelector(
        "[name~=csrf-token][content]"
      ).content;

      const preCode = document.querySelector("#precode");
      const code = document.querySelector("#code");
      const statusDiv = document.querySelector(".status");

      console.log("Running..");
      const response = await fetch("/query", {
        method: "POST", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, *cors, same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
        redirect: "follow", // manual, *follow, error
        referrerPolicy: "no-referrer", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
        body: JSON.stringify({ query: this.textInput }), // body data type must match "Content-Type" header
      })
        .then((response) => response.json())
        .then((json) => {
          code.innerHTML = JSON.stringify(json.response, null, "  ");

          // Set status
          statusDiv.textContent = json.status;
          statusDiv.classList = `status status-${json.status}`;

          removeClass(preCode, "hidden");
          hljs.highlightBlock(code);
        });
    },
  };
};

export default queryPage;
