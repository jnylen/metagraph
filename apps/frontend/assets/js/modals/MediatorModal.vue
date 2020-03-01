<template>
  <div class>
    <modal :name="type" :width="600">
      <div class="flex flex-col h-full">
        <div class="flex justify-between w-full px-4 py-4">
          <h1 class="font-bold">{{ type }}</h1>
          <span class="hover:cursor-pointer" v-on:click="$modal.hide(type)">❌</span>
        </div>
        <div
          class="flex flex-col justify-center flex-1 w-full h-full px-8 py-2 bg-indigo-100 shadow-inner"
        >
          <div
            v-bind:key="field.predicate"
            v-for="field in fields"
            class="flex items-center py-3 language"
          >
            <span class="w-1/4 pr-4 font-semibold text-right">Language</span>
            <input
              type="text"
              class="w-2/3 px-4 py-2 leading-tight text-gray-700 bg-white border-2 border-gray-200 rounded appearance-none focus:outline-none focus:bg-white focus:border-indigo-700"
            />
          </div>
        </div>
        <div class="flex justify-end px-4 py-4">
          <button
            class="px-3 py-2 mr-2 font-sans text-base leading-none tracking-tight text-gray-700 bg-gray-300 rounded hover:cursor-pointer hover:bg-gray-400"
          >Cancel</button>
          <button
            v-bind:disabled="!isOK"
            v-bind:class="{ 'disabled': !isOK }"
            class="px-3 py-2 font-sans text-base leading-none tracking-tight text-white bg-indigo-500 rounded hover:cursor-pointer hover:bg-indigo-600"
          >+ Add</button>
        </div>
      </div>
    </modal>
    <span
      class="px-3 py-1 font-sans text-lg leading-none tracking-tighter text-white bg-indigo-500 rounded-full hover:cursor-pointer hover:bg-indigo-600"
      v-on:click="$modal.show(type)"
    >+</span>
  </div>
</template>

<script>
export default {
  name: "MediatorModal",
  props: ["type", "fields", "uid"],
  data() {
    return {
      form: {}
    };
  },
  computed: {
    required_predicates: function() {
      return this.fields.filter(fields => {
        return item.required;
      });
    },
    isOK: function() {
      var filtered = this.form;

      this.required_predicates.forEach(filter => {
        filtered = filtered.filter(record => {
          return this.isNotBlank(record[filter.predicate]);
        });
      });

      //return this.isNotBlank(this.label) && this.isNotBlank(this.lang);
    }
  }
};
</script>

<style>
</style>
