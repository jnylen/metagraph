<template>
  <div class>
    <div v-if="!compType">
      <div class="font-roboto text-brand-ind">
        <h1 class="mb-3 text-3xl font-bold">Create an item</h1>
        <p class="text-lg">Choose a specific type the item is.</p>
      </div>
      <div class="flex flex-wrap pt-5">
        <div
          v-for="specificType in available_types"
          v-bind:key="selectType.id"
          class="flex w-1/2 pt-5 pr-2"
          v-on:click="selectType(specificType)"
        >
          <div
            class="flex items-center w-full p-4 bg-white border-2 border-transparent rounded shadow transition-border hover:border-indigo-500 hover:cursor-pointer"
          >
            <div class="w-1/5 mr-3 text-4xl text-center text-indigo-500">
              <i :class="specificType.icon"></i>
            </div>
            <div>
              <h4 class="pb-1 font-extrabold">{{ specificType.label }}</h4>
              <p class="text-sm">{{ specificType.description }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="compType">
      <div class="pb-4 font-roboto text-brand-ind">
        <h1 class="mb-3 text-2xl font-bold">Create a {{ compType.label.toLowerCase() }}</h1>
      </div>
      <form method="post" accept-charset="UTF-8">
        <input type="hidden" name="type[]" :value="chosen_type.id" />
        <input type="hidden" name="_csrf_token" :value="csrf" />
        <h5 class="text-sm font-semibold text-indigo-900">Common</h5>
        <div class="px-6 pt-10 pb-6 mt-2 mb-10 bg-white rounded shadow">
          <div class="flex flex-wrap mb-8">
            <div class="w-full px-3 mb-6 md:w-1/2 md:mb-0">
              <label
                class="block mb-2 text-xs font-bold tracking-wide text-indigo-900 uppercase"
                for="grid-first-name"
              >Language *</label>
              <div class="relative">
                <select
                  v-model="lang"
                  name="language"
                  class="block w-full px-4 py-3 pr-8 leading-tight text-indigo-900 bg-gray-200 border border-gray-200 rounded appearance-none focus:outline-none focus:bg-white focus:border-gray-500"
                  id="grid-state"
                >
                  <option
                    v-for="lang in languages"
                    :value="lang.code"
                    :key="lang.code"
                  >{{lang.name}}</option>
                </select>
                <div
                  class="absolute inset-y-0 right-0 flex items-center px-2 text-indigo-900 pointer-events-none"
                >
                  <svg
                    class="w-4 h-4 fill-current"
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 20 20"
                  >
                    <path
                      d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
                    />
                  </svg>
                </div>
              </div>
            </div>
            <div class="w-full px-3 md:w-1/2">
              <label
                class="block mb-2 text-xs font-bold tracking-wide text-indigo-900 uppercase"
                for="grid-last-name"
              >Label *</label>
              <input
                v-model="label"
                name="label"
                class="block w-full px-4 py-3 leading-tight text-indigo-900 bg-gray-200 border border-gray-200 rounded appearance-none focus:outline-none focus:bg-white focus:border-gray-500"
                id="grid-last-name"
                type="text"
                placeholder="Item name/label"
              />
            </div>
          </div>

          <div class="mb-6">
            <div class="w-full px-3 mb-6 md:mb-0">
              <label
                class="block mb-2 text-xs font-bold tracking-wide text-indigo-900 uppercase"
                for="grid-first-name"
              >Description</label>
              <textarea
                v-model="description"
                rows="5"
                name="description"
                class="block w-full px-4 py-3 leading-tight text-indigo-900 bg-gray-200 border border-gray-200 rounded appearance-none focus:outline-none focus:bg-white focus:border-gray-500"
                placeholder="The description of an item"
              />
            </div>
          </div>
        </div>
        <div v-if="chosen_type.externals.length">
          <div class="flex items-center justify-between pt-8">
            <h5 class="text-sm font-semibold text-indigo-900">Externals</h5>
            <span class="text-sm font-light text-gray-700">Checks are done to check the uniqueness</span>
          </div>
          <div class="px-6 pt-10 pb-6 mt-2 bg-white rounded shadow">
            <div class="flex flex-wrap">
              <div
                v-for="check in chosen_type.externals"
                v-bind:key="check.predicate"
                class="w-full px-3 mb-6 md:w-1/2"
              >
                <label
                  class="block mb-2 text-xs font-bold tracking-wide text-indigo-900 uppercase"
                  for="grid-last-name"
                >{{check.label}}</label>
                <input
                  :name="check.predicate"
                  class="block w-full px-4 py-3 leading-tight text-indigo-900 bg-gray-200 border border-gray-200 rounded appearance-none focus:outline-none focus:bg-white focus:border-gray-500"
                  id="grid-last-name"
                  type="text"
                  :placeholder="check.example"
                />
              </div>
            </div>
          </div>
        </div>
        <div class="mt-8 text-center">
          <button
            v-bind:disabled="!isOK"
            v-bind:class="{ 'disabled': !isOK }"
            class="px-4 py-3 leading-none text-white bg-indigo-500 rounded-full font-oxygen"
            type="submit"
          >Create item</button>
          <p
            class="px-12 pt-8 text-sm leading-tight text-brand-ind"
          >By clicking on "Create item" you allow us to relicense the contributed data under various licenses by our choice without being able to rescind the allowance.</p>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: "CreateItem",
  props: {
    prop_chosen_type: String,
    available_types: Array,
    languages: Array,
    csrf: String
  },
  data() {
    return {
      label: null,
      lang: null,
      description: null,
      chosen_type: null
    };
  },
  computed: {
    isOK: function() {
      return this.isNotBlank(this.label) && this.isNotBlank(this.lang);
    },
    compType: function() {
      if (this.isNotBlank(this.prop_chosen_type)) return this.prop_chosen_type;

      return this.chosen_type;
    }
  },
  methods: {
    selectType(type) {
      console.log(this);
      this.chosen_type = type;
    },
    isNotBlank(text) {
      return text != "" && text != null;
    }
  }
};
</script>
