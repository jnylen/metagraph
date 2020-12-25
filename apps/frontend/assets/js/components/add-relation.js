export const relationsSelect = (relation_type, relations) => {
  return {
    relation_type: relation_type || "",
    openSearch: false,
    textInput: "",
    results: [],
    relations: relations || [],
    searchRelation: async function () {
      console.log(this.textInput);

      const response = await fetch(
        `/ajax/relations?type=${this.relation_type}&q=${this.textInput}`
      );

      const data = await response.json();
      this.results = data;
    },
    clearSearch() {
      this.textInput = "";
    },
    addRelation(data) {
      this.relations.push(data);
      this.results = this.results.filter((item) => item !== data);
    },
    removeRelation(data) {
      this.relations = this.relations.filter((item) => item !== data);
    },
  };
};

export const relationSelect = (relation_type, relation) => {
  return {
    relation_type: relation_type || "",
    openSearch: false,
    textInput: "",
    results: [],
    relation: relation || null,
    searchRelation: async function () {
      console.log(this.textInput);

      const response = await fetch(
        `/ajax/relations?type=${this.relation_type}&q=${this.textInput}`
      );

      const data = await response.json();
      this.results = data;
    },
    clearSearch() {
      this.textInput = "";
    },
    addRelation(data) {
      this.relation = data;
      this.results = [];
    },
    removeRelation(data) {
      this.relation = null;
    },
  };
};

export default { relationsSelect, relationSelect };
