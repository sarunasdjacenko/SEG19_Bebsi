<template>
  <div id="view-staff">
    <div class="container" style="width:100%;">
      <table class="collection with-header" style="background: white;width:100%;height:auto">
        <thead class="collection-header">
          <h4 style="padding:20px;font-size:3em;">
            <b>Staff</b>
          </h4>

          <tr style="font-size:1.5em">
            <th style="padding: 20px;">Role</th>
            <th>Email</th>
            <th>Name</th>
            <th>Department</th>
            <th></th>
          </tr>
        </thead>

        <tbody v-for="user in users" v-bind:key="user.email" class="collection-item">
          <tr>
            <td style="padding: 20px;">
              {{user.role}}
              <i
                class="material-icons"
                v-if="user.email == currentEmail"
              >accessibility_new</i>
            </td>
            <td>{{user.email}}</td>
            <td>{{user.name}}</td>
            <td>{{user.dept}}</td>
            <td>
              <router-link
                v-bind:to="{name: 'edit-staff', params: {email: user.email}}"
                class="secondary-content left"
              >
                <button
                  id="editBtn"
                  v-if="user.email == currentEmail || user.role != 'Admin'"
                  class="btn blue"
                  style="position:relative;text-align:center;"
                >edit</button>
              </router-link>
            </td>
            <td>
              <button
                id="deleteBtn"
                v-if="user.role != 'Admin'"
                class="btn red"
                @click="deleteUser(user.email)"
              >Delete</button>
            </td>
          </tr>
        </tbody>
        <router-link id="addStaffBtn" to="/register" class="btn green" style="margin:20px">Add Member</router-link>
      </table>
    </div>
  </div>
</template>

<script>
import { userMixin } from "../../mixins/usersMixin/userMixin";

export default {
  name: "view-staff",
  mixins: [userMixin],
  created() {
    this.getLoggedInUser();
    this.getUsersInfo();
  }
};
</script>

