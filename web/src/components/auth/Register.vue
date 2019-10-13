<template>
  <div>
    <div class="container" style="padding-top:10em">
      <div class="row">
        <div class="col s12 m8 offset-m2">
          <div class="login card-panel white blue-text center">
            <h3>Register</h3>
            <form @submit.prevent="register">
              <div class="input-field">
                <i class="material-icons prefix">email</i>
                <input
                  placeholder="Email"
                  type="text"
                  name="email"
                  id="email"
                  v-model="email"
                  required
                >
              </div>
              <div class="input-field">
                <i class="material-icons prefix">lock</i>
                <input
                  placeholder="Password"
                  type="password"
                  name="password"
                  id="password"
                  v-model="password"
                  required
                >
              </div>

              <div class="input-field">
                <i class="material-icons prefix">face</i>

                <input
                  placeholder="Name"
                  type="text"
                  name="first"
                  id="first"
                  v-model="name"
                  required
                >
              </div>
              <div class="input-field">
                <i class="material-icons prefix">assignment</i>
                <input
                  placeholder="Department"
                  type="text"
                  name="department"
                  id="department"
                  v-model="dept"
                  required
                >
              </div>

              <div class="input-field">
                <p style="margin-right: 100%">
                  <i style="margin-left:8px" class="material-icons prefix blue-text">assignment_ind</i>
                  <label style="border-bottom:1px solid #9e9e9e;">
                    <input id="check" type="checkbox" class="filled-in" style="margin-top:10px">
                    <span class="blue-text" style="margin-top:10px">Admin</span>
                  </label>
                </p>
              </div>

              <button
                id="registerBtn"
                style="margin-top:70px"
                type="submit"
                class="btn btn-large blue lighten-2 black-text"
              >Register</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { authMixin } from "../../mixins/authMixin/authMixin";
export default {
  name: "register",
  mixins: [authMixin]
};
</script>
