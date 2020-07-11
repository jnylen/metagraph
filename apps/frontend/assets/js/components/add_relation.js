const relationSelect = (relations) => {
  return {
    relation_type: "",
    openSearch: false,
    textInput: "",
    results: [],
    relations: relations || [],
    searchRelation: async function () {
      console.log(this.textInput);

      const response = await fetch(
        `/ajax/relations?type=${this.relation_type}&q=${this.textInput}`
      );

      //const data = await response.json();
      //this.images = data.hits;
    },
    clearSearch() {
      this.textInput = "";
    },
    addRelation() {},
    removeRelation() {},
  };
};

export default relationSelect;
