<template>
  <div class="mainContainer" id="new-prep-faq">
    <h3>New FAQ</h3>
    <div class="row">
      <ul>
        <li>
          <div class="col s12">
            <div class="card-panel light-blue">
              <span class="card-title white-text">
                <i class="small material-icons">info_outline</i>Info
              </span>
              <p class="white-text">
                Enter a question and its answer in the respective fields below.
                <br>
                <br>Add information and chat buttons to this question to take the patient directly to that page.
              </p>
            </div>
          </div>
        </li>
      </ul>
    </div>
    <div class="row">
      <form @submit.prevent="saveFAQ" class="col s12">
        <!-- adds a question input field -->
        <div class="row">
          <div class="input-field col s12">
            <span id="title">Question*</span>
            <input type="text" v-model="question" required>
          </div>
        </div>
        <!-- adds an answer input field -->
        <div class="row">
          <div class="input-field col s12">
            <span id="title">Answer*</span>
            <input type="text" v-model="answer" required>
          </div>
        </div>
        <!-- adds 2 checkboxes representing shortcuts in the app -->
        <div class="row">
          <div class="input-field col s12">
            <p style="margin-right: 100%">
              <label>
                <input id="chatCheck" type="checkbox" class="filled-in">
                <span class="blue-text">Has chat shortcut?</span>
              </label>
            </p>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <p style="margin-right: 100%">
              <label>
                <input id="informationCheck" type="checkbox" class="filled-in">
                <span class="blue-text">Has information shortcut?</span>
              </label>
            </p>
          </div>
        </div>
        <div>
          <button id="submitButton" type="submit" class="btn">Submit</button>
          <!-- cancel button -->
          <router-link
            id="cancelButton"
            v-bind:to="{name: 'view-prep-faqs', params: {test_id: this.$route.params.test_id}}"
            class="btn grey"
          >Cancel</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { faqsMixin } from "../../../mixins/faqsMixin/faqsMixin.js";
export default {
  name: "new-prep-faqs",
  mixins: [faqsMixin]
};
</script>
<style scoped>
#title {
  color: #2196f3;
}
</style>
