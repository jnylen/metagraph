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

require("./liveview.js").default

// // Import Vue
// import Vue from "vue";

// // Add third party plugins
// import vmodal from "vue-js-modal";
// Vue.use(vmodal);

// // Add components
// Vue.component("create-item", require("./components/CreateItem.vue").default);
// Vue.component(
//   "multipredicate",
//   require("./components/MultiPredicate.vue").default
// );

// // Add modals
// Vue.component("language-modal", require("./modals/LanguageModal.vue").default);
// Vue.component("relation-modal", require("./modals/RelationModal.vue").default);
// Vue.component("mediator-modal", require("./modals/MediatorModal.vue").default);

// const app = new Vue({
//   el: "#app"
// });

// function show(id) {
//   var x = document.getElementById(id);
//   if (x.style.display === "none") {
//     x.style.display = "block";
//   } else {
//     x.style.display = "none";
//   }
// }
