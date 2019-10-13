<template>
  <div class="mainContainer" id="edit-employee">
    <h3>Edit User</h3>
    <div class="row">
      <form @submit.prevent="updateUser" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <span>Email:</span>
            <input disabled type="text" v-model="email" required>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Name:</span>
            <input type="text" v-model="name" required>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Department:</span>
            <input type="text" v-model="dept" required>
          </div>
        </div>
        <div class="row">
          <div class="input-field col s12">
            <span>Role:</span>
            <input disabled type="text" v-model="role" required>
          </div>
        </div>
        <button id="submit" type="submit" class="btn">Submit</button>
        <router-link to="/view-staff" class="btn grey">Cancel</router-link>
      </form>
    </div>
  </div>
</template>

<script>
import { userMixin } from "../../mixins/usersMixin/userMixin";

export default {
  name: "edit-staff",
  mixins: [userMixin],
  created() {
    this.preloadFields();
  },
  watch: {
    $route: "fetchData"
  }
};
</script>

<style>
span {
  color: #2196f3;
}
</style>