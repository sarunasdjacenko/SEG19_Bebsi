<template>
  <div class="mainContainer" id="edit-article">
    <div id="mainScreen" class="row">
      <h3>Edit Article</h3>
      <form @submit.prevent="updateArticle" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <p>Title</p>
            <input type="text" v-model.trim="title" required>
          </div>
        </div>
        <ul class="collapsible">
          <li>
            <div class="collapsible-header">
              <i class="small material-icons">info_outline</i>Info
            </div>
            <div class="collapsible-body">
              <span>
                Please use the text area below to enter information about this article. If this information is not currently available,
                you can leave this blank for now and edit the information later.
                <br>
                <br>Images can also be uploaded by clicking on the
                image icon. Images should be placed inbetween blocks of text so that they correctly display in the app.
                <br>
                <br>When entering web links, please ensure they are copied directly from the browser bar. Eg starting with https rather than www.
              </span>
            </div>
          </li>
        </ul>
        <div class="loaderWrapper">
          <!-- Spinner that displays during image upload -->
          <div v-if="!dataLoaded" id="loader">
            <div id="el" class="preloader-wrapper big active">
              <div class="spinner-layer spinner-blue-only">
                <div class="circle-clipper left">
                  <div class="circle"></div>
                </div>
                <div class="gap-patch">
                  <div class="circle"></div>
                </div>
                <div class="circle-clipper right">
                  <div class="circle"></div>
                </div>
              </div>
            </div>
            <label style="font-size:25px">Loading... please wait</label>
          </div>
        </div>
        <div v-if="dataLoaded">
          <textEditor
            :editorInformation="htmlForEditor"
            :editorImages="imagesForEditor"
            ref="textEditor"
          />
        </div>
        <div class="navButtons">
          <button type="submit" class="btn">Submit</button>
          <router-link
            v-bind:to="{name: 'view-articles', params: {test_id: test_id, test_title: test_title}}"
            class="btn grey"
          >Cancel</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { articleQueryMixin } from "../../../mixins/articleMixin/articleQueryMixin";
import { articleMixin } from "../../../mixins/articleMixin/articleMixin";

export default {
  name: "addArticle",
  mixins: [articleQueryMixin, articleMixin],
  data() {
    return {};
  },
  created() {
    // get the article by id given in route
    this.getArticle();
  }
};
</script>

<style scoped>
.navButtons {
  padding-top: 10px;
}
p {
  color: #2196f3;
}
h3 {
  font-weight: bold;
  margin-left: 20px;
}
.collapsible-header {
  color: #2196f3;
}
</style>