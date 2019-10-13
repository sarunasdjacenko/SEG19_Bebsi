// This mixin will be used for any functionality that is shared between the navigation components.
// To make use of the functionality in this file import { navigationMixin } from '(this location)'
// and then add 'mixins: [navigationMixin]' just before the data of the component.

import db from '../../components/firebaseInit'
import firebase from 'firebase/app'

export const navigationMixin = {
    data() {
        return {
            // shared data for navigation
            isLoggedIn: false,
            currentUser: false,
            isAdmin: null,
            user: {}
        }
    },

    methods: {

        // retrieve the user information for displaying in the sidebar
        getUser() {
            if (firebase.auth().currentUser) {
                this.isLoggedIn = true
                this.currentUser = firebase.auth().currentUser.email
                db.collection("users")
                    .where("email", "==", firebase.auth().currentUser.email)
                    .get()
                    .then(querySnapshot => {
                        querySnapshot.forEach(doc => {
                            if (doc.exists) {
                                this.user = {
                                    email: doc.data().email,
                                    dept: doc.data().dept,
                                    role: doc.data().role
                                }
                                // this.user.push(data)
                                this.isAdmin = doc.data().role
                            }
                        })
                    })
            }
        },

        // log the user out and refresh the screen to display the login screen
        logout() {
            firebase
                .auth()
                .signOut()
                .then(() => {
                    location.reload();
                })
        }
    },
    mounted() {
        // initialise sidebar component
        M.AutoInit()
    }
}