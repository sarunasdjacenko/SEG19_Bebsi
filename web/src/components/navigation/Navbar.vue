<template>
  <div class="navbar-fixed">
    <nav v-if="isLoggedIn">
      <div class="nav-wrapper white">
        <img
          style="height:50px;margin-top:6px;"
          src="static/webIcon.png"
          alt="Prep."
          class="brand-logo left"
        >
        <router-link
          to="/"
          style="margin-left:50px"
          class="brand-logo hide-on-med-and-down"
          id="logo"
        >Prep.</router-link>
        <ul>
          <li class="right">
            <button v-on:click="logout" class="btn red" style="margin-left: 10px">Logout</button>
          </li>
        </ul>
      </div>
    </nav>
  </div>
</template>

<script>
import { navigationMixin } from "../../mixins/navigationMixin/navigationMixin";

export default {
  name: "navbar",
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
span {
  margin-right: 10px;
}
li {
  position: left;
}
.right {
  padding-right: 30px;
}
#logo {
  margin-left: 10px;
  font-size: 2.5em;
  font-weight: bold;
}
.router {
  margin-left: 120px !important;
  font-size: 20px !important;
  color: #999999;
  font-weight: bold;
}
.menuItem {
  font-size: 20px !important;
  color: #999999 !important;
  font-weight: bold !important;
}
.btn-rout {
  width: 60%;
}
.brand-logo {
  color: darkblue !important;
}
</style>