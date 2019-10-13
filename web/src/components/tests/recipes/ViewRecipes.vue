<template>
  <div id="view-recipes">
    <ul class="collection with-header">
      <li class="collection-header">
        <div class="container" style="width:100%;height:100%">
          <table class="collection with-header" style="background: white;width:100%;height:auto">
            <thead class="collection-header">
              <h4 style="padding:20px;font-size:3em;">
                <b>Recipes</b>
              </h4>
              <tr style="font-size:1.5em">
                <th style="padding: 20px;">Dish Name</th>
                <th>Description</th>
              </tr>
            </thead>
            <tbody v-for="recipe in recipes" v-bind:key="recipe.id" class="collection-item">
              <tr>
                <td class="truncate" style="padding: 20px;">{{recipe.title}}</td>
                <td>
                  <router-link
                    v-bind:to="{name: 'view-recipe-info', params: {test_id: testID, recipe_id: recipe.id}}"
                    class="btn blue"
                  >Show</router-link>
                </td>
              </tr>
            </tbody>
            <router-link
              v-bind:to="{name: 'new-recipe', params: {test_id: testID}}"
              class="btn green"
            >Add Recipe</router-link>
            <router-link to="/view-tests">
              <button class="btn grey" style="margin:10px;">Back</button>
            </router-link>
          </table>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import { recipeMixin } from "../../../mixins/recipeMixin/recipeMixin";
import { recipeQueryMixin } from "../../../mixins/recipeMixin/recipeQueryMixin";

export default {
  name: "view-recipes",
  mixins: [recipeMixin, recipeQueryMixin],
  data() {
    return {
      recipes: [],
      testID: this.$route.params.test_id
    };
  },
  created() {
    this.getRecipes();
  }
};
</script>

<style scoped>
td {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 400px;
}
</style>