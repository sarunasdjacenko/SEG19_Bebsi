// This mixin will be used for queries that are shared between the test components.
// To make use of the functionality in this file import { testQueryMixin } from '(this location)'
// and then add 'mixins: [testQueryMixin]' just before the data of the component.

import db from '../../components/firebaseInit'

export const testQueryMixin = {

  methods: {

    // get all tests
    getTests() {
      db.collection("tests")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            const data = {
              id: doc.id,
              test_id: doc.data().testID,
              title: doc.data().title,
              department: doc.data().type
            }
            this.tests.push(data)
          })
        })
    },


    // get a test by the id in the route
    getTest() {
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .get()
        .then(doc => {
          if (doc.exists) {
            this.title = doc.data().title
            this.department = doc.data().type
            this.htmlForEditor = doc.data().description
            this.imagesForEditor = doc.data().editorImages
            this.dataLoaded = true
          }
        })
    },

    // add the new test to the database
    saveTest() {
      // run the editors save method
      this.$refs.textEditor.saveEditorData()
      // save the document
      db.collection('tests').add({
        title: this.title,
        type: this.department,
        description: (this.$refs.textEditor.htmlForEditor === undefined ? '' : this.$refs.textEditor.htmlForEditor),
        editorImages: this.$refs.textEditor.images
      })
        .then(docRef => {
          console.log("Document written with ID: ", docRef.id);
          alert(`New test: ` + this.title + ` saved!`)
        })
        .catch(error => {
          console.error("Error adding document: ", error);
          return // dont leave the page if save fails
        })
      // return to tests page
      this.$router.push({ path: '/view-tests' })
    },

    // update a current test in the database
    updateTest() {
      // run the editors save method
      this.$refs.textEditor.saveEditorData()
      // update the document
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .update({
          title: this.title,
          type: this.department,
          description: this.$refs.textEditor.htmlForEditor,
          editorImages: this.$refs.textEditor.images
        })
        .then(() => {
          alert("Test info updated!")
        })
        .catch((error) => {
          console.error("Error writing document: ", error)
          return // dont leave the page if save fails
        })
      // return to tests page
      this.$router.push("/view-tests")
    },


    // delete a test from the database
    deleteTest(id, title) {
      if (confirm("Are you sure you want to delete this test: " + title)) {
        db.collection("tests")
          .doc(id)
          .delete()
          .then(() => {
            console.log("Document successfully deleted")
            location.reload()
            alert("test: " + title + " deleted")
          })
          .catch((error) => {
            console.error("Error removing document: ", error)
          })
      }
    }
  }
}