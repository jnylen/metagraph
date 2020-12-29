const formToJSON = function (form) {
  let data = new FormData();
  for (let i = 0; i < form.length; i++) {
    const item = form[i];
    //data[item.name] = item.value;
    data.append(item.name, item.value);
  }
  return data;
};

export function Modal(models) {
  return {
    // other default properties
    results: [],
    show_modal: false,
    models: models || {},
    submitForm: function () {
      const csrfToken = document.head.querySelector(
        "[name~=csrf-token][content]"
      ).content;

      const query = formToJSON(this.$el.querySelectorAll("input,select"));

      const response = fetch("/ajax/save", {
        method: "POST", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, *cors, same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
          "X-CSRF-Token": csrfToken,
        },
        redirect: "follow", // manual, *follow, error
        referrerPolicy: "no-referrer", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
        body: query, // body data type must match "Content-Type" header
      })
        .then((response) => response.json())
        .then((json) => {
          if (json.status == "ok") {
            this.show_modal = false;
          } else {
            console.log("couldnt save..");
          }
        });
    },
  };
}
