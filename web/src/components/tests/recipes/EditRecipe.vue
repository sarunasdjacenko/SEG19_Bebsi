<template>
  <div class="mainContainer" id="add-article">
    <div id="edit-recipe">
      <h3>Edit Recipe</h3>
      <div class="row">
        <div class="col s12">
          <div class="card-panel light-blue">
            <span class="card-title white-text">
              <i class="small material-icons">info_outline</i>Info
            </span>
            <p class="white-text">
              Fill in the fields below and then click submit. A title is required, along with a recipe link or an ingredients list with instructions.
              <br>Please ensure that web links are valid and appears in full (ie begins with “http://www.” or “https://www.”) otherwise it may not be shown in the app even if provided online.
              <br>Please do not add too many tags for the recipe (3 - 4 maximum)
              <br>Finally, you can upload a header image for the recipe. We recommend images of around 1000 pixels by 250 pixels, without transparency.
            </p>
          </div>
        </div>
        <form @submit.prevent="updateRecipe" class="col s12">
          <div class="row">
            <div class="input-field col s12">
              <span id="title">Title*</span>
              <input type="text" v-model="title" required>
            </div>
            <div class="input-field col s12">
              <span id="title">Subtitle</span>
              <input type="text" v-model="subtitle">
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <span id="title">Link</span>
              <input type="text" v-model="externalURL">
            </div>
          </div>
          <div>
            <div>
              <span id="title">Ingredients</span>
            </div>
            <button
              @click="addIngredient"
              class="btn green"
              id="addBtn"
              type="button"
            >add ingredient</button>
            <div class="row">
              <div
                v-for="(ingredient, index) in ingredients"
                v-bind:key="index"
                class="input-field inline col s12"
              >
                <div class="valign-wrapper">
                  <input type="text" v-model="ingredients[index]" required>
                  <a class="btn-floating red" @click="deleteIngredient(index)" id="removeBtn">
                    <i class="material-icons">close</i>
                  </a>
                </div>
              </div>
            </div>
            <div>
              <span id="title">instructions</span>
            </div>
            <button
              @click="addInstruction"
              class="btn green"
              id="addBtn"
              type="button"
            >add instruction</button>
            <div class="row">
              <div
                v-for="(instruction, index) in instructions"
                v-bind:key="index"
                class="input-field col s12"
              >
                <div class="valign-wrapper">
                  <input type="text" v-model="instructions[index]" required>
                  <a class="btn-floating red" @click="deleteInstruction(index)" id="removeBtn">
                    <i class="material-icons">close</i>
                  </a>
                </div>
              </div>
            </div>
          </div>
          <div>
            <span id="title">Tags</span>
          </div>
          <div class="row">
            <div id="tags" class="input-field col s6">
              <!-- chips component for recipe tags -->
              <div class="chips chips-placeholder"></div>
            </div>
          </div>
          <div>
            <span id="title">Recipe type</span>
          </div>
          <div class="row">
            <div class="input-field col s6">
              <select v-model="recipeType">
                <option v-for="type in recipeTypes" v-bind:key="type.index" :value="type">{{type}}</option>
              </select>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <span id="title">Notes</span>
              <input type="text" v-model="note">
            </div>
          </div>
          <div class="row">
            <imageUploader id="addBtn" :imageURL="imageURL" v-on:downloadURL="imageURL=$event"/>
          </div>
          <button type="submit" class="btn">Submit</button>
          <router-link
            v-bind:to="{name: 'view-recipe-info', params: {test_id: test_id, recipe_id: recipe_id}}"
            class="btn grey"
          >Cancel</router-link>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { recipeMixin } from "../../../mixins/recipeMixin/recipeMixin";
import { recipeQueryMixin } from "../../../mixins/recipeMixin/recipeQueryMixin";

export default {
  name: "edit-recipe",
  mixins: [recipeMixin, recipeQueryMixin],
  data() {
    return {
      test_id: this.$route.params.test_id,
      recipe_id: this.$route.params.recipe_id
    };
  },
  created() {
    this.getRecipe(this.test_id, this.recipe_id);
  }
};
</script>

<style scoped>
#title {
  color: #2196f3;
}
#addBtn {
  margin: 15px;
}
#removeBtn {
  margin-right: 10px;
  margin-left: 10px;
}
</style>