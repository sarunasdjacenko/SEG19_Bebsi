// This mixin will be used for any functionality that is shared between the staff components.
// To make use of the functionality in this file import { userMixin } from '(this location)'
// and then add 'mixins: [userMixin]' just before the data of the component.

import db from "../../components/firebaseInit";
import firebase from "firebase/app";
import 'firebase/auth'
export const userMixin = {
  data() {
    return {
      // Part of the View Staff Component.
      users: [],
      isAdmin: null,
      currentEmail: null,
      // Part of the Edit Staff Component.
      email: null,
      name: null,
      dept: null,
      role: null
    };
  },
  methods: {
    /*
        This method gets the currently clicked user information.
        (Watched by the $route)
        
        Part of the Edit Staff Component.
    */
    fetchData() {
      db.collection("users")
        .where("email", "==", this.$route.params.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.email = doc.data().employee_id;
            this.name = doc.data().name;
            this.dept = doc.data().dept;
            this.role = doc.data().role;
          });
        });
    },
    /*
        This method updates the user information on
        firestore.

        Part of the Edit Staff Component.
    */
    updateUser() {
      db.collection("users")
        .where("email", "==", this.$route.params.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            doc.ref
              .update({
                email: this.email,
                name: this.name,
                dept: this.dept,
                role: this.role
              })
              .then(() => {
                alert("User info updated!");
                this.$router.push("/view-staff");
              });
          });
        });
    },
    /*
        This code is executed before page load,
        in order to fill all the fields with the
        needed user information.
 

        Part of the Edit Staff Component.
    */
    preloadFields() {
      db.collection("users")
        .where("email", "==", this.$route.params.email)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.email = doc.data().email;
            this.name = doc.data().name;
            this.dept = doc.data().dept;
            this.role = doc.data().role;
          });
        });
    },
    /*
        Get the information specifically for the
        currently logged in user.

        Part of the View Staff Component.
    */
    getLoggedInUser() {
      if (firebase.auth().currentUser) {
        db.collection("users")
          .where("email", "==", firebase.auth().currentUser.email)
          .get()
          .then(querySnapshot => {
            querySnapshot.forEach(user => {
              this.isAdmin = user.data().role;
              this.currentEmail = user.data().email;
            });
          });
      }
    },
    /*
        Get the information for all users in the firestore.

        Part of the View Staff Component.
    */
    getUsersInfo() {
      db.collection("users")
        .where("email", "<", "\uf8ff")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(user => {
            const data = {
              email: user.data().email,
              name: user.data().name,
              dept: user.data().dept,
              role: user.data().role
            };
            this.users.push(data);
          });
        });
    },
    /*
        This method deletes the clicked user
        from firestore and removes it from the user table.

        Part of the View Staff Component.
    */
    deleteUser(userEmail) {
      if (confirm(`Are you sure you want to delete user ${userEmail}`)) {
        db.collection("users")
          .where("email", "==", userEmail)
          .get()
          .then(querySnapshot => {
            querySnapshot.forEach(doc => {
              doc.ref
                .delete()
                .then(() => {
                  console.log("Document successfully deleted!");
                  alert(`Successfully deleted user ${userEmail}`);
                  location.reload();
                })
                .catch(function (error) {
                  console.error("Error removing document: ", error);
                  alert(`There was an error: ${error}`);
                });
            });
          });
      }
    }
  }
};
