<template>
  <div class="mainContainer" id="add-test">
    <div id="mainScreen" class="row">
      <h3>Add Test</h3>
      <form @submit.prevent="saveTest" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <p>Title</p>
            <input type="text" v-model.trim="title" required>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <p>Department</p>
            <input type="text" v-model.trim="department" required>
          </div>
        </div>
        <ul class="collapsible">
          <li>
            <div class="collapsible-header">
              <i class="small material-icons">info_outline</i>Info
            </div>
            <div class="collapsible-body">
              <span>
                Please use the text area below to enter information about this test. If this information is not currently available,
                you can leave this blank for now and edit the information later.
                <br>
                <br>Images can also be uploaded by clicking on the image icon. Images should be placed in-between blocks of text so that they correctly display in the app.
                <br>
                <br>When entering web links, please ensure they are copied directly from the browser bar. Eg starting with https rather than www.
              </span>
            </div>
          </li>
        </ul>
        <div>
          <textEditor ref="textEditor"/>
        </div>
        <div class="navButtons">
          <button type="submit" class="btn">Submit</button>
          <router-link to="/view-tests" class="btn grey">Cancel</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { testQueryMixin } from "../../mixins/testMixin/testQueryMixin";
import { testMixin } from "../../mixins/testMixin/testMixin";

export default {
  name: "addTest",
  mixins: [testQueryMixin, testMixin],
  data() {
    return {};
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
  margin-left: 20px;
}
.collapsible-header {
  color: #2196f3;
}
</style>