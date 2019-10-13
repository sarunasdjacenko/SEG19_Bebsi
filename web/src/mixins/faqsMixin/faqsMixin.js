// This mixin will be used for any functionality that is shared between the faqs components.
// To make use of the functionality in this file import { faqsMixin } from '(this location)'
// and then add 'mixins: [faqsMixin]' just before the data of the component.

import db from "../../components/firebaseInit";

export const faqsMixin = {
  data() {
    return {
      faqs: [],
      testID: this.$route.params.test_id,
      question: null,
      answer: null,
      chatShortcut: false,
      informationShortcut: false,
      test_id: this.$route.params.test_id
    };
  },
  methods: {
    createFaqs() {
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("prepCards")
        .where("type", "==", "faqs")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            const data = {
              id: doc.id, // the id of the document in the database
              answer: doc.data().answer,
              chatShortcut: doc.data().chatShortcut,
              informationShortcut: doc.data().informationShortcut,
              question: doc.data().question
            };
            this.faqs.push(data);
          });
        });
    },
    deleteFAQ(id) {
      if (confirm("Are you sure?")) {
        db.collection("tests")
          .doc(this.$route.params.test_id)
          .collection("prepCards")
          .doc(id)
          .delete()
          .then(() => {
            // refresh page
            alert('FAQ deleted')
            console.log("FAQ successfully deleted!");
            location.reload();
          });

      }
    },
    saveFAQ() {
      // gets the value of the checkboxes
      if (document.getElementById("chatCheck").checked) {
        this.chatShortcut = true;
      }
      if (document.getElementById("informationCheck").checked) {
        this.informationShortcut = true;
      }

      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("prepCards")
        .add({
          title: "Frequently Asked Questions",
          type: "faqs",
          question: this.question,
          answer: this.answer,
          chatShortcut: this.chatShortcut,
          informationShortcut: this.informationShortcut
        })
        // reroutes to faqs page
        .then(docRef => {
          alert('FAQ added!')
          this.$router.push({
            name: "view-prep-faqs",
            params: {
              test_id: this.$route.params.test_id
            }
          });
        })
        .catch(error => console.log(err));
    },
    updateFAQ() {
      // gets the value of the checkbox
      if (document.getElementById("chatCheck").checked) {
        this.chatShortcut = true;
      }
      if (document.getElementById("informationCheck").checked) {
        this.informationShortcut = true;
      }
      // updates the fields in the database
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("prepCards")
        .doc(this.$route.params.faq_id)
        .get()
        .then(doc => {
          doc.ref
            .update({
              question: this.question,
              answer: this.answer,
              chatShortcut: this.chatShortcut,
              informationShortcut: this.informationShortcut
            })
            .then(() => {
              // route back to faq viewing page
              alert("FAQ edited!");
              this.$router.push({
                name: "view-prep-faqs",
                params: { test_id: this.$route.params.test_id }
              });
            });
        });
    },
    // sets values of fields before entering the page
    createEditPrepFaq() {
      db.collection("tests")
        .doc(this.$route.params.test_id)
        .collection("prepCards")
        .doc(this.$route.params.faq_id)
        .get()
        .then(doc => {
          this.question = doc.data().question;
          this.answer = doc.data().answer;
          this.chatShortcut = doc.data().chatShortcut;
          this.informationShortcut = doc.data().informationShortcut;
        });
    }
  }
}