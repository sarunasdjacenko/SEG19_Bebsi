<template>
  <div class="mainContainer" id="add-article">
    <div id="mainScreen">
      <h3>New Recipe</h3>
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
        <form @submit.prevent="saveRecipe" class="col s12">
          <div class="row">
            <div class="input-field col s12">
              <input type="text" v-model="title" id="title" maxlength="70" required>
              <label for="title">Title *</label>
            </div>
            <div class="input-field col s12">
              <input type="text" id="subtitle" maxlength="70" v-model="subtitle">
              <label for="subtitle">Subtitle</label>
            </div>
          </div>
          <div>
            <div class="row">
              <div class="input-field col s12">
                <input type="text" id="recipeLink" v-model="externalURL">
                <label for="recipeLink">Recipe link</label>
              </div>
            </div>
          </div>
          <div>
            <div>
              <label id="heading">Ingredients</label>
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
                class="input-field col s12"
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
              <label id="heading">Instructions</label>
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
          <div class="row">
            <div id="tags" class="input-field col s6 left">
              <label id="heading">Recipe tags</label>
              <!-- chips component for recipe tags -->
              <div class="chips chips-placeholder" style="padding-top: 40px;"></div>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s6">
              <select v-model="recipeType">
                <option value disabled selected>
                  <label>Choose Recipe type</label>
                </option>
                <option v-for="type in recipeTypes" v-bind:key="type.index" :value="type">{{type}}</option>
              </select>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <input type="text" id="notes" class="materialize-textarea" v-model="note">
              <label for="notes">Notes</label>
            </div>
          </div>
          <imageUploader id="addBtn" v-on:downloadURL="imageURL=$event"/>
          <br>
          <button type="submit" class="btn">Submit</button>
          <router-link
            v-bind:to="{name: 'view-recipes', params: {test_id: this.$route.params.test_id}}"
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
  name: "new-recipe",
  mixins: [recipeMixin, recipeQueryMixin],
  data() {
    return {
      test_id: this.$route.params.test_id,
      recipe_id: this.$route.params.recipe_id
    };
  }
};
</script>

<style scoped>
#heading {
  font-size: 15px;
}
#tags {
  padding-bottom: 15px;
}
#addBtn {
  margin: 10px;
}
</style>