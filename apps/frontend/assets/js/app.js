// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import scss from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";
import "alpinejs";
import topbar from "topbar";
import "@kollegorna/cocoon-vanilla-js";

require("./liveview.js").default;

// Show progress bar on live navigation and form submits
topbar.config({
  barColors: { 0: "#4f46e5" },
  shadowColor: "rgba(0, 0, 0, .3)",
});
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

import { relationsSelect, relationSelect } from "./components/add-relation";
window.relationSelect = relationSelect;
window.relationsSelect = relationsSelect;

import queryPage from "./components/query-page";
window.queryPage = queryPage;

import { Modal } from "./components/modal";
window.Modal = Modal;
