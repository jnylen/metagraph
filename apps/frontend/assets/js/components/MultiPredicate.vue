<template>
  <div>
    <multiselect
      v-model="selected"
      id="ajax"
      label="best_label"
      track-by="uid"
      placeholder="Type to search"
      open-direction="bottom"
      :options="values"
      :multiple="multiple"
      :searchable="true"
      :loading="isLoading"
      :internal-search="false"
      :clear-on-select="false"
      :close-on-select="false"
      :options-limit="300"
      :limit="3"
      :limit-text="limitText"
      :max-height="600"
      :show-no-results="false"
      :hide-selected="true"
      @search-change="asyncFind"
      @input="selectValue"
    >
      <template slot="tag" slot-scope="{ option, remove }">
        <span class="px-3 py-1 text-white bg-indigo-500 rounded-full">
          <span>{{ option.best_label || option.label }}</span>
          <span class="ml-1 custom__remove" @click="remove(option)">❌</span>
        </span>
      </template>
      <span slot="noResult">No results found.</span>
    </multiselect>
  </div>
</template>

<script>
import { HTTP } from "../http-client";
import Multiselect from "vue-multiselect";

export default {
  props: {
    predicate: Object,
    selected_values: Array,
    item: Object,
    multiple: Boolean
  },
  components: {
    Multiselect
  },
  data() {
    return {
      values: [],
      selected: this.selected_values,
      isLoading: false
    };
  },
  computed: {
    isOK: function() {
      return this.isNotBlank(this.label) && this.isNotBlank(this.lang);
    },
    selectedValues: function() {
      return this.selected_values || [];
    }
  },
  methods: {
    selectValue(type) {
      HTTP.post("/save", {
        uid: this.item.uid,
        predicate: this.predicate.name,
        value: type
      })
        .then(response => {
          this.isLoading = false;
        })
        .catch(e => {
          this.isLoading = false;
          //this.errors.push(e);
        });
    },
    isNotBlank(text) {
      return text != "" && text != null;
    },
    limitText(count) {
      return `and ${count} other edges`;
    },
    asyncFind(query) {
      console.log(this.predicate);

      this.isLoading = true;
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
    },
    clearAll() {
      this.selected = [];
    }
  }
};
</script>
