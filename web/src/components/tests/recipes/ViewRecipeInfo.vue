<template>
  <div id="view-recipe-info">
    <ul class="collection with-header" style="border: none;">
      <li class="collection-header">
        <h4>Recipe Information:</h4>
      </li>
      <li v-if="imageURL" class="collection-item">
        <div class="center-align">
          <img :src="imageURL" width="100%" style="max-height: 250px; max-width: 250px;">
        </div>
      </li>
      <li class="collection-item">
        <b>Dish Name:</b>
        {{title}}
        <i v-if="subtitle">- {{subtitle}}</i>
      </li>
      <li v-if="recipeType" class="collection-item">
        <b>Recipe type:</b>
        {{recipeType}}
      </li>
      <li v-if="labels" class="collection-item">
        <b>Labels:</b>
        {{labels}}
      </li>
      <li v-if="externalURL" class="collection-item">
        <b>Recipe link:</b>
        <a :href="externalURL">{{externalURL}}</a>
      </li>
      <li v-if="ingredients" class="collection-item">
        <b>Ingredients:</b>
        <ol>
          <li v-for="ingredient in ingredients" v-bind:key="ingredient">{{ ingredient }}</li>
        </ol>
      </li>
      <li v-if="instructions" class="collection-item">
        <b>Instructions:</b>
        <ol>
          <li v-for="instruction in instructions" v-bind:key="instruction">{{ instruction }}</li>
        </ol>
      </li>
      <li v-if="note" class="collection-item">
        <b>Notes:</b>
        {{note}}
      </li>
      <li class="collection-item">
        <div>
          <router-link
            v-bind:to="{name: 'view-recipes', params: {test_id: test_id}}"
            class="btn grey"
          >Back</router-link>
          <router-link
            v-bind:to="{name: 'edit-recipe', params: {test_id: test_id, recipe_id: recipe_id}}"
            class="btn green"
          >Edit</router-link>
          <button @click="deleteRecipe" class="btn red">Delete</button>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import { recipeMixin } from "../../../mixins/recipeMixin/recipeMixin";
import { recipeQueryMixin } from "../../../mixins/recipeMixin/recipeQueryMixin";

export default {
  name: "view-recipe-info",
  mixins: [recipeMixin, recipeQueryMixin],
  data() {
    return {
      test_id: this.$route.params.test_id,
      recipe_id: this.$route.params.recipe_id
    };
  },
  created() {
    this.getRecipe(this.test_id, this.recipe_id);
  },
  methods: {
    // overdie the load chips methods as this component dosent use chips
    loadChips() {}
  }
};
</script>