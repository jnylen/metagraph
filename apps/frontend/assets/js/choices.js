import Choices from 'choices.js';
import { HTTP } from "../http-client";

const choices = new Choices('.js-choice');
choices.setChoices(async () => {
    HTTP.post("/find_edges", {
        query: query,
        edges: this.predicate.models
      })
        .then(response => {
          this.values = response.data;
          this.isLoading = false;
        })
        .catch(e => {
          this.isLoading = false;
          //this.errors.push(e);
        });
  });
