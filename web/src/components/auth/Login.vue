<template>
  <div id="login">
    <div class="container" style="padding-top:10em">
      <div class="row">
        <div class="col s12 m8 offset-m2">
          <div class="login card-panel white blue-text center">
            <h3>Login</h3>
            <form>
              <div class="input-field">
                <i class="material-icons prefix">email</i>
                <input placeholder="Email" type="text" name="email" id="email" v-model="emailLog">
              </div>
              <div class="input-field">
                <i class="material-icons prefix">lock</i>
                <input
                  placeholder="Password"
                  type="password"
                  name="password"
                  id="password"
                  v-model="passwordLog"
                >
              </div>
              <button
                id="loginBtn"
                v-on:click="login"
                class="btn btn-large blue lighten-2 black-text"
              >Login</button>
              <router-link
                id="resetPasswordBtn"
                to="/resetPassword"
                style="margin-left:50px;"
              >Forgot Password?</router-link>
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
  name: "login",
  mixins: [authMixin]
};
</script>

<style scoped>
input.text {
  padding-left: 10px;
}
#login {
  margin: 0;
  position: relative;
  top: 50%;
  left: 7%;
}
</style>
