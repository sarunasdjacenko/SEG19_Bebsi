// This mixin will be used for any functionality that is shared between the staff components.
// To make use of the functionality in this file import { appointmentMixin } from '(this location)'
// and then add 'mixins: [appointmentMixin]' just before the data of the component.

import db from "../../components/firebaseInit";
import firebase from "firebase/app";
import "firebase/auth";

export const appointmentMixin = {
  data() {
    return {
      //Part of the ViewAppointment Component.
      dailyCheckupsView: [],
      appointmentsView: [],
      testName: null,
      testType: null,
      router: this.$route.params.id, // used in Edit as well
      newMap: new Map(),
      past: this.$route.params.expired,
      //Part of the EditAppointment Component
      date: "",
      time: "",
      code: null,
      location: null,
      staffMember: null,
      users: [],
      expired: this.$route.params.expired,
      contactNumber: "",
      //Part of the AddAppointment Component
      testID: null,
      currentUser: "",
      tests: [],
      doctor: ""
    };
  },
  methods: {
    /*
        This method gets the information for the specified
        appointment with doc id given by the router.

        Part of the ViewAppointment Component.
    */
    getAppointmentInfo() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .get()
        .then(doc => {
          const data = {
            testID: doc.data().testID,
            date: doc
              .data()
              .datetime.toDate()
              .toISOString()
              .split("T")[0],
            time: doc
              .data()
              .datetime.toDate()
              .toTimeString()
              .split(" ")[0],
            location: doc.data().location
          };
          this.appointmentsView.push(data);
          this.getTestInfo();
        });
    },
    /*
        This methid gets the needed information from the 
        tests collection with a doc id specified in the
        clicked appointment.

        Part of the ViewAppointment Component.
    */
    getTestInfo() {
      db.collection("tests")
        .doc(this.appointmentsView[0].testID)
        .get()
        .then(doc => {
          if (doc.data() != undefined) {
            (this.testName = doc.data().title),
              (this.testType = doc.data().type);
          }else{
            this.testName = "Unavailable"
            this.testType = "Unavailable"
          }
        });
    },
    /*
        This method listens live to the dailyCheckups 
        collection in the clicked appointment in order
        to get if any changes were made.

        Part of the ViewAppointment Component.
    */
    listenDailyCheckups() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .collection("dailyCheckups")
        .orderBy("daysBeforeTest", "desc")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            // on page load
            if (change.type == "added") {
              const data = {
                docId: change.doc.id,
                daysBeforeTest: change.doc.data().daysBeforeTest,
                instructions: change.doc.data().instructions
              };

              this.dailyCheckupsView.push(data);
            }
            // if modified (e.g set to true)
            if (change.type == "modified") {
              for (var i = 0; i < this.dailyCheckupsView.length; i++) {
                if (
                  this.dailyCheckupsView[i].daysBeforeTest ==
                  change.doc.data().daysBeforeTest
                ) {
                  this.dailyCheckupsView[
                    i
                  ].instructions = change.doc.data().instructions;
                  this.dailyCheckupsView.push();
                }
              }
            }
          });
        });
    },
    /*
        This method gets the data from all users
        in the firestore.

        Part of the EditAppointment Component.
    */
    getAllUsers() {
      db.collection("users")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(user => {
            const data = {
              dept: user.data().dept,
              email: user.data().email,
              name: user.data().name,
              role: user.data().role,
              Ucode: user.id
            };
            this.users.push(data);
          });
        });
    },
    /*
        This method gets the data and loads
        all the fields.

        Part of the EditAppointment Component.
    */
    loadFields() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .get()
        .then(doc => {
          if (doc.exists) {
            this.date = doc
              .data()
              .datetime.toDate()
              .toISOString()
              .split("T")[0];
            this.time = doc
              .data()
              .datetime.toDate()
              .toTimeString()
              .split(" ")[0];
            this.location = doc.data().location;
            this.testID = doc.data().testID;
            this.staffMember = doc.data().staffMember;
            this.code = doc.id;
            this.contactNumber = doc.data().contactNumber;
          }
        });
    },
    /*
      This method updates the information
      for the specified appointment on firestore.

      Part of the EditAppointment Component.
    */
    updateAppointment() {
      db.collection("appointments")
        .doc(this.$route.params.id)
        .update({
          location: this.location,
          datetime: firebase.firestore.Timestamp.fromDate(
            new Date(Date.parse(this.date + "T" + this.time + "Z"))
          ),
          staffMember: this.staffMember.Ucode,
          doctor: this.staffMember.name,
          contactNumber: this.contactNumber
        })
        .then(() => {
          alert("Appointments info updated!");
          this.$router.push("/view-appointments");
        })
        .catch(function (error) {
          console.error("Error writing document: ", error);
        });
    },
    /*
        This method gets all the information
        from the tests collection in firestore.

        Part of the AddAppointment Component
    */
    getTests() {
      // Get all the information from tests collection
      db.collection("tests")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(test => {
            const data = {
              testID: test.id,
              title: test.data().title,
              type: test.data().type
            };
            this.tests.push(data);
          });
        });
    },
    /*
        This method checks if the generated code
        exists in firestore. It also calls the method
        that generates the code.

        Part of the AddAppointment Component
    */
    checkIfCodeExists() {
      this.generateCode().then(foc => {
        if (foc == true) {
          // recursively generate a new code
          document.getElementById("mainScreen").style.display = "none";
          this.checkIfCodeExists();
        } else {
          // hide loader and show main screen
          document.getElementById("el").classList.remove("active");
          document.getElementById("loader").style.display = "none";
          document.getElementById("mainScreen").style.display = null;
        }
      });
    },
    /*
        This method generates a random code of length 9
        and puts it as the doc id in the appointments' collection.

        Part of the AddAppointment Component

        @return Promise
    */
    generateCode() {
      var ID = Math.random()
        .toString(36)
        .substr(2, 9);
      this.code = ID; // for testing purposes
      var docRef = db.collection("appointments").doc(ID);
      return docRef
        .get()
        .then(doc => {
          if (doc.exists) {
            return true;
          } else {
            this.code = ID;
            return false;
          }
        })
        .catch(function (error) {
          alert(error);
        });
    },
    /*
        This method creates a new appointment and
        sets each field. 

        Part of the AddAppointment Component
    */
    saveAppointment() {
      db.collection("appointments")
        .doc(this.code)
        .set({
          datetime: firebase.firestore.Timestamp.fromDate(
            new Date(Date.parse(this.date + "T" + this.time + "Z"))
          ),
          location: this.location,
          staffMember: this.staffMember,
          testID: this.testID.testID,
          expired: false,
          doctor: this.doctor,
          testName: this.testID.title,
          used: false,
          contactNumber: this.contactNumber
        })
        .then(docRef => {
          this.addDailyCheckups();
          alert(
            "Successfully created new appointment with code " + this.code + " !"
          );
          this.$router.push("/view-appointments");
        })
        .catch(error => console.log(error));
    },
    /*
        This method gets the dailyCheckup collection
        from tests and adds it to the newly created appointment.

        Part of the AddAppointment Component
    */
    addDailyCheckups() {
      db.collection("tests")
        .doc(this.testID.testID)
        .collection("dailyCheckups")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            db.collection("appointments")
              .doc(this.code)
              .collection("dailyCheckups")
              .add(doc.data())
              .then(docRef => {
                console.log("Added dailyCheckup");
              })
              .catch(error => console.log(error));
          });
        });
    },
    /*
        This method gets the document id of
        the currently logged in person.

        Part of the AddAppointment Component
    */
    getDocId() {
      if (firebase.auth().currentUser == null) {
        this.currentUser = "e@e.com"
      } else {
        this.currentUser = firebase.auth().currentUser.email
      }
      db.collection("users")
        .where("email", "==", this.currentUser)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.staffMember = doc.id;
            this.doctor = doc.data().name;
          });
        });
    }
  }
};
