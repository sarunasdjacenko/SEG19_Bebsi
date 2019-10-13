// This mixin will be used for any functionality that is shared between the staff components.
// To make use of the functionality in this file import { viewAppointmentsMixin } from '(this location)'
// and then add 'mixins: [viewAppointmentsMixin]' just before the data of the component.

import db from "../../components/firebaseInit";
import firebase from "firebase/app";
import "firebase/auth";

export const viewAppointmentsMixin = {
  data() {
    return {
      // Part of the Appointments Component.
      appointments: [],
      allAppointments: [],
      dailyCheckups: [],
      notifications: [],
      ids: [],
      staffMemberID: "",
      today: new Date(),
      yesterday: null,
      currentDate: Date.now().toLocaleString,
      pastString: ""
    };
  },
  methods: {
    /*
        This method sets the date for yesterday and pastString.

        Part of the Appointments Component.
      */
    setDate() {
      this.yesterday = new Date(this.today.setDate(this.today.getDate() - 1));
      if (this.past) {
        this.pastString = "Past ";
      }
    },
    /*
          This method sorts the appointments collection into two 
          collections of past and current appointments. It takes into account
          the expired boolean as well as the date.
  
          Part of the Appointments Component.
      */
    sortByExpiration() {
      var pastAppointments = [];
      var currentAppointments = [];
      for (var i = 0; i < this.appointments.length; i++) {
        if (
          this.appointments[i].datetime.toDate() < this.today ||
          this.appointments[i].expired == true
        ) {
          if (this.appointments[i].expired == false) {
            this.expireAppointment(this.appointments[i].code, true);
          }
          pastAppointments.push(this.appointments[i]);
        } else if (
          this.appointments[i].datetime.toDate() > this.yesterday &&
          this.appointments[i].expired == false
        ) {
          currentAppointments.push(this.appointments[i]);
        }
      }
      // Assign the appropriate array to the appointments array
      if (this.past) {
        this.appointments = pastAppointments;
      } else {
        this.appointments = currentAppointments;
      }
      this.allAppointments = this.appointments;
    },
    /*
          This method sorts the appointments either in asc or
          desc order.
  
          Part of the Appointments Component.
      */
    sortByOrder() {
      // @ts-ignore
      var selectValue = document.getElementById("select").value;
      this.clearData(); // clears all input field values and arrays
      // @ts-ignore
      document.getElementById("searchCode").value = "";
      // @ts-ignore
      document.getElementById("datePicker").value = "";
      if (selectValue == "Date") {
        // Sort by date asc
        this.getAppointments("asc");
      } else if (selectValue == "Date desc") {
        // Sort by date desc
        this.getAppointments("desc");
      }
    },
    /*
          This method sorts the appointments by a specific
          date specified by the user.
  
          Part of the Appointments Component.
      */
    sortByDate() {
      // @ts-ignore
      var value = document.getElementById("datePicker").value;
      var newDay = new Date(value);
      var newAppointments = [];
      for (var i = 0; i < this.allAppointments.length; i++) {
        var date = this.allAppointments[i].datetime.toDate();
        var wholeDate =
          date.getDate().toString() +
          date.getMonth().toString() +
          date.getFullYear().toString();
        var convertWholeDate =
          newDay.getDate().toString() +
          newDay.getMonth().toString() +
          newDay.getFullYear().toString();

        if (wholeDate == convertWholeDate) {
          newAppointments.push(this.allAppointments[i]);
          // Get the notifications
          this.fetchData(this.allAppointments[i].id);
        }
      }
      // if a match has been found
      if (newAppointments.length != 0) {
        this.clearData();
        this.appointments = newAppointments;
        this.appointments.push();
      } else {
        if (value == "") {
          alert("Please enter a date first!");
        } else {
          alert("No appointments scheduled for " + value + "!");
        }
        this.clearData();
        this.getAppointments("asc");
        // @ts-ignore
        document.getElementById("datePicker").value = "";
      }
      // @ts-ignore
      document.getElementById("searchCode").value = "";
      // @ts-ignore
      document.getElementById("select").value = "Date";
    },
    /*
          This method sorts the appointments by a specified code.
          If there is a substring that matches the whole appointment(s)
          will be returned,
  
          Part of the Appointments Component.
      */
    sortByCode() {
      // @ts-ignore
      var inputValue = document.getElementById("searchCode").value;
      var codeArray = [];
      for (var i = 0; i < this.allAppointments.length; i++) {
        if (
          this.allAppointments[i].code.includes(inputValue) &&
          inputValue != ""
        ) {
          codeArray.push(this.allAppointments[i]);
        }
      }
      // if there is a match
      if (codeArray.length != 0) {
        this.clearData();
        this.appointments = codeArray;
        this.appointments.push();
      } else {
        if (inputValue != "") {
          alert("No code found for " + inputValue + " !");
        } else {
          alert("Nothing to search for...");
        }
        // @ts-ignore
        document.getElementById("searchCode").value = "";
      }
      // @ts-ignore
      document.getElementById("select").value = "Date";
    },
    /*
          This method makes sure it will take the
          information only for the currently logged in
          user. 
  
          Part of the Appointments Component.
      */
    loadUser() {
      var mail = "";
      if (firebase.auth().currentUser == null) {
        mail = "example@example.com";
      } else {
        mail = firebase.auth().currentUser.email;
      }
      db.collection("users")
        .where("email", "==", mail)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            this.isAdmin = doc.data().role;
            this.staffMemberID = doc.id;
          });
        });
    },
    /*
          This method gets all the appointments for the
          logged in user and orders them either asc or decs
          datetime.
  
          Part of the Appointments Component.
      */
    getAppointments(dir) {
      db.collection("appointments")
        .orderBy("datetime", dir)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(appointment => {
            if (appointment.data().staffMember == this.staffMemberID) {
              const data = {
                code: appointment.id,
                datetime: appointment.data().datetime,
                staffMember: appointment.data().staffMember,
                location: appointment.data().location,
                id: appointment.id,
                testID: appointment.data().testID,
                expired: appointment.data().expired
              };
              this.appointments.push(data);
              this.listenForDailyCheckups(appointment.id);
              this.fetchData(appointment.id);
            }
          });
          this.sortByExpiration(); // sorts the array by date
        });
    },
    /*
          This method gets the number of dailyCheckups marked
          as true as well as the length of the instructions array.
  
          Part of the Appointments Component.
      */
    getDailyCheckups(id, bool) {
      var count = 0;
      var length = 0;
      db.collection("appointments")
        .doc(id)
        .collection("dailyCheckups")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            // Get only the number of completed dailyCheckups
            Object.values(doc.data().instructions).forEach(map => {
              if (map.answer) {
                count++;
              }
              length++;
            });
          });
          const data = {
            id: id,
            count: count,
            length: length
          };
          // if true it means sth. needs to be pushed to the array
          if (bool) {
            this.dailyCheckups.push(data);
          }
          for (var i = 0; i < this.dailyCheckups.length; i++) {
            if (this.dailyCheckups[i].id == id) {
              this.dailyCheckups[i] = data;
              this.dailyCheckups.push();
            }
          }
        });
    },
    /*
          This method listen live to the changes on the firestore
          and gets any changes made to the dailyCheckups collection.
  
          Part of the Appointments Component.
      */
    listenForDailyCheckups(id) {
      this.dailyCheckups = [];
      this.getDailyCheckups(id, true);
      db.collection("appointments")
        .doc(id)
        .collection("dailyCheckups")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            if (change.type == "modified") {
              // just edit the dailyCheckups
              this.getDailyCheckups(id, false);
            }
          });
        });
    },
    /*
          This method listens live to the firestore in order
          to get if any unseen messages have been received from
          a user(patient).
  
          Part of the Appointments Component.
      */
    fetchData(id) {
      db.collection("appointments")
        .doc(id)
        .collection("messages")
        .where("seenByStaff", "==", false)
        .where("isPatient", "==", true)
        .onSnapshot(snapshot => {
          // @ts-ignore
          // @ts-ignore
          // @ts-ignore
          // @ts-ignore
          snapshot.docChanges().forEach(change => {
            var count = snapshot.size;
            if (this.ids.indexOf(id) != -1) {
              var index = this.ids.indexOf(id);
              this.notifications[index] = count;
              this.notifications.push();
            } else {
              this.notifications.push(count);
              this.ids.push(id);
            }
          });
        });
    },
    /*
          This method deletes an appointment with a specified
          code (doc id).
  
          Part of the Appointments Component.
      */
    deleteAppointment(code) {
      if (confirm(`Are you sure you want to delete this appointment`)) {
        db.collection("appointments")
          .doc(code)
          .delete()
          .then(() => {
            console.log("Document successfully deleted!");
            alert(`Successfully deleted appointment ` + code);
            location.reload();
          })
          .catch(function (error) {
            console.error("Error removing document: ", error);
            alert(`There was an error: ${error}`);
          });
      }
    },
    /*
          This method marks an appointment as expired,
          meaning it will be sent to the past appointments
          collection.
  
          Part of the Appointments Component.
      */
    expireAppointment(id, bool) {
      // Make a specific appointment expired
      if (bool == false) {
        if (
          confirm(
            "Are you sure you want to mark appointment " + id + " as expired?"
          )
        ) {
          db.collection("appointments")
            .doc(id)
            .update({
              expired: true
            })
            .then(function () {
              location.reload();
              console.log("Document successfully over-written!");
            })
            .catch(function (error) {
              console.error("Error writing document: ", error);
            });
        }
      } else {
        db.collection("appointments")
          .doc(id)
          .update({
            expired: true
          })
          .then(function () {
            console.log("Document successfully over-written!");
          })
          .catch(function (error) {
            console.error("Error writing document: ", error);
          });
      }
    },
    /*
          This method resets all the input field values
          as well as the arrays and runs the query again to
          get all appointments.
  
          Part of the Appointments Component.
      */
    resetTable() {
      // @ts-ignore
      document.getElementById("resetBtn").disabled = true;
      // @ts-ignore
      window.setTimeout(function () {
        // @ts-ignore
        document.getElementById("resetBtn").disabled = false;
      }, 500);

      this.clearData();
      // @ts-ignore
      document.getElementById("select").value = "Date";
      // @ts-ignore
      document.getElementById("datePicker").value = "";
      // @ts-ignore
      document.getElementById("searchCode").value = "";
      this.getAppointments("asc");
    },
    /*
          This method sets all arrays except, 
          dailyCheckups and tests, to empty.
  
          Part of the Appointments Component.
      */
    clearData() {
      this.appointments = [];
      this.notifications = [];
      this.ids = [];
    }
  }
};
