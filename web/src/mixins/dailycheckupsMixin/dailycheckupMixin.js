import db from "../../components/firebaseInit";
import firebase from "firebase/app";

export const dailycheckupMixin = {
  data() {
    return {
      daily_id: '',
      timeArray: [],
      allInstr: [],
      allInstrArray: [],
      instructions: [],
      daysBeforeTest: null
    }
  },
  methods: {
    //get daily checkups data for view daily check-ups page

    getCheckup() {
      db.collection('tests')
        .doc(this.$route.params.test_id)
        .collection('dailyCheckups')
        .orderBy('daysBeforeTest', 'desc')
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            const data = {
              'id': doc.id,
              'daysBeforeTest': doc.data().daysBeforeTest,
              'instrcutions': doc.data().instructions,
            }
            this.dailyCheckups.push(data)
          })
        })
    },
    //get daily checkups data for view daily check-ups information page
    getDaily(test_id, daily_id) {
      db.collection("tests")
        .doc(test_id)
        .collection("dailyCheckups")
        .doc(daily_id)
        .get()
        .then(doc => {
          this.code = doc.id;
          this.instructions = doc.data().instructions;
          this.daysBeforeTest = doc.data().daysBeforeTest;
        })
    },
    //get daily checkups data for edit daily check-ups page
    getCheckups() {
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("dailyCheckups")
        .doc(this.$route.params.daily_id)
        .get()
        .then(doc => {
          (this.code = doc.id),
            (this.allInstr = doc.data().instructions),
            (this.daysBeforeTest = doc.data().daysBeforeTest)

          for (const [key, value] of Object.entries(this.allInstr)) {
            //convert the elements in insturction field to a new array 
            this.allInstrArray.push(value.question)
            //convert the last checked time to a new array
            this.timeArray.push(value.lastChecked)
          }
        })
    },
    /*
      This method is used for deleting the daily checkups and 
      pops up an alert window for checking.
    */
    deleteDailyCheckups() {
      if (confirm("Are you sure you want to delete this Daily Checkup?")) {
        db.collection("tests")
          .doc(this.$route.params.test_id)
          .collection("dailyCheckups")
          .doc(this.$route.params.daily_id)
          .get()
          .then(doc => {
            if (doc.exists) {
              doc.ref
                .delete()
                .then(() => {
                  console.log("Document successfully deleted!");
                  alert(`Successfully deleted Daily Checkup!`);
                  location.reload();
                })
                .catch(function (error) {
                  console.error("Error removing document: ", error);
                  alert(`There was an error: ${error}`);
                })
            }
          })
      }
    },
    /*
    This method creates an empty map which is inserted by the 
    elements from the instructions array. Then assign this map
    to daily checkup's instruction field.
    */
    saveDailyCheckups() {
      var map = {};
      var lastChecked = firebase.firestore.Timestamp.fromDate(
        new Date(Date.now())
      );
      for (var i = 0; i < this.instructions.length; i++) {
        map[i] = { answer: false, question: this.instructions[i].value, lastChecked: lastChecked };
      }

      var l = Object.keys(map).length
      if (l > 0) {
        db.collection("tests")
          .doc(this.$route.params.test_id)
          .collection("dailyCheckups")
          .add({
            instructions: map,
            daysBeforeTest: Number(this.daysBeforeTest)
          })
          .then(docRef => {
            alert("Successfully created new Daily Check-ups!");
            this.$router.push({
              name: "view-dailycheckups",
              params: { test_id: this.$route.params.test_id }
            })
          })
          .catch(error => console.log(err));
      }
      else {
        alert("You must add at least one instruction")
      }
    },
    /*
    This method put all the elements in the array to the 
    instruction map and update all the data in daily checkups.
    */
    updateDailyCheckups() {
      //delete all the elements in instructions.
      for (var member in this.allInstr) delete this.allInstr[member]

      //add the original elements to the instruction map 
      for (var i = 0; i < this.allInstrArray.length; i++) {
        this.allInstr[i] = { answer: false, lastChecked: this.timeArray[i], question: this.allInstrArray[i] }
      }

      //get the length of the instruction
      var l = Object.keys(this.allInstr).length

      //appending new element to the instruction map
      for (var i = l; i < this.instructions.length + l; i++) {
        this.allInstr[i] = {
          answer: false, lastChecked: firebase.firestore.Timestamp.fromDate(new Date(Math.floor(Date.now()))),
          question: this.instructions[i - l].value
        }
      }

      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("dailyCheckups")
        .doc(this.$route.params.daily_id)
        .get()
        .then(doc => {
          if (doc.exists) {
            doc.ref
              .update({
                instructions: this.allInstr,
                daysBeforeTest: Number(this.daysBeforeTest),
              })
              .then(() => {
                alert("You have updated the Daily check-ups!");
                this.$router.push({
                  name: "view-dailycheckups",
                  params: { test_id: this.$route.params.test_id }
                });
              });
          }
        })
    },
    /*
    This method add an instruction as an element of the instructions array.
    */
    addInstruction() {
      const data = { value: "" };
      this.instructions.push(data);
    },
    /*
    This method delete the instruction which added.
    */
    deleteInstruction(index) {
      this.instructions.splice(index, 1);
    },
    /*
    This method delete the element in all instruction array in edit page
   */
    deleteInstructionEdit(index) {
      this.allInstrArray.splice(index, 1);
    },
    /*
    This method delete the instruction which added in edit page.
    */
    deleteAddedInstruction(index) {
      this.instructions.splice(index, 1);
    }


  }
};