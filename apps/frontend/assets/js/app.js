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
import "@kollegorna/cocoon-vanilla-js";

require("./liveview.js").default;

import relationSelect from "./components/add_relation";
window.relationSelect = relationSelect;
