// This mixin will be used for any functionality that is shared between the staff components.
// To make use of the functionality in this file import { authMixin } from '(this location)'
// and then add 'mixins: [authMixin]' just before the data of the component.

import db from "../../components/firebaseInit";
import firebase from "firebase/app";

export const authMixin = {
  data() {
    return {
      // Part of the Register Component.
      email: "",
      password: "",
      name: "",
      dept: "",
      role: "Staff",
      // Part of the Login Component.
      emailLog: "",
      passwordLog: "",
    };
  },
  methods: {
    /*
        This function creates a new user on firestore as well
        as google authentication service

        Part of the Register Component
    */
    register: function (e) {
      if (this.name != null && this.dept != null && this.role != null) {
        firebase
          .auth()
          .createUserWithEmailAndPassword(this.email, this.password)
          .then(
            user => {
              // @ts-ignore
              if (document.getElementById("check").checked) {
                this.role = "Admin";
              }
              db.collection("users")
                .add({
                  email: this.email.toLowerCase(),
                  name: this.name,
                  dept: this.dept,
                  role: this.role
                })
                .then(userRef => {
                  alert(`Registration Successful!`);
                  window.location.href = "/";
                })
                .catch(error => console.log(error));
            },
            err => {
              alert(err.message);
            }
          );
        e.preventDefault();
      }
    },
    /*
        Verify the user by sending a request to the firestore
        and create a new Session.

        Part of the Login Component
    */
    login: function (e) {
      firebase.auth().setPersistence(firebase.auth.Auth.Persistence.SESSION);
      firebase
        .auth()
        .signInWithEmailAndPassword(this.emailLog, this.passwordLog)
        .then(
          user => {
            location.reload();
          },
          err => {
            alert(err.message);
          }
        );
      e.preventDefault();
    },
    /*
      This method sends a pre-made email with a restoration
      link.

      Part of the ResetPassword Component
    */
    sendResetEmail: function () {
      // @ts-ignore
      var email = document.getElementById("email").value;
      firebase
        .auth()
        .sendPasswordResetEmail(email)
        .then(function () {
          // Password reset email sent.
          alert(`Password email has been sent to ${email}`);
          window.location.href = "/";
        })
        .catch(function (error) {
          // Error occurred. Inspect error.code.
          alert(error);
        });
    }
  }
};
