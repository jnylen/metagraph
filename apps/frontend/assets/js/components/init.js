import { addEventListener } from "@kollegorna/js-utils/src/event";

const initializer = (func) => {
  addEventListener(document, "phx:page-loading-stop", func);
  addEventListener(document, "DOMContentLoaded", func);
};

export default initializer;
