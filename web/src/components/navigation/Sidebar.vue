<template>
  <div v-if="isLoggedIn">
    <!-- the side bar will be shown by default on large displays and hidden on smaller ones -->
    <div class="col s0 m0 l2">
      <ul id="slide-out" class="sidenav sidenav-fixed">
        <div id="user">
          <li>
            <span id="role" class="email black-text">
              {{user.role}}
              <router-link
                id="settings"
                v-bind:to="{name: 'edit-staff', params: {email: currentUser}}"
              >
                <i class="fa fa-cog right sidenav-close"></i>
              </router-link>
            </span>
          </li>
          <li>
            <span id="email" class="email black-text">{{currentUser}}</span>
          </li>
        </div>
        <li>
          <div class="divider"></div>
        </li>
        <li>
          <router-link
            to="/view-appointments"
            class="menuItem sidenav-close"
            exact-active-class="exact active"
            exact
          >Current Appointments</router-link>
        </li>
        <li>
          <router-link
            to="/past-appointments"
            class="menuItem sidenav-close"
            exact-active-class="exact active"
            exact
          >Past Appointments</router-link>
        </li>
        <li>
          <router-link
            v-if="isAdmin == 'Admin'"
            to="/view-staff"
            class="menuItem sidenav-close"
            exact-active-class="exact active"
            exact
          >Staff</router-link>
        </li>
        <li>
          <router-link
            to="/view-tests"
            class="menuItem sidenav-close"
            exact-active-class="exact active"
            exact
          >Tests</router-link>
        </li>
        <li>
          <router-link to="/add-appointment" class="btn red sidenav-close">Add Appointment</router-link>
        </li>
      </ul>

      <a href="#" data-target="slide-out" class="sidenav-trigger">
        <i class="material-icons">menu</i>
      </a>
    </div>
  </div>
</template>

<script>
import { navigationMixin } from "../../mixins/navigationMixin/navigationMixin";

export default {
  name: "sidebar",
  mixins: [navigationMixin],
  data() {
    return {};
  },
  created() {
    // get user information on creation
    this.getUser();
  }
};
</script>

<style>
.menuItem:hover,
.menuItem.router-link-active,
.menuItem.router-link-exact-active {
  cursor: pointer;
  background-color: rgb(240, 240, 240);
}
.sidenav-trigger {
  color: white;
  position: fixed;
}
#settings {
  font-size: 20px;
  color: darkgrey;
}
#central {
  padding-left: 85px;
}
#slide-out {
  width: 270px;
  overflow: hidden;
  margin-top: 65px;
}
#user {
  text-align: center;
  padding-top: 30px;
  padding-bottom: 30px;
}
#role {
  text-align: center;
  font-size: 2em;
  font-weight: bold;
}
</style>


