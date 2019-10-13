// This mixin will be used for any functionality that is shared between the staff components.
// To make use of the functionality in this file import { messageMixin } from '(this location)'
// and then add 'mixins: [messageMixin]' just before the data of the component.

import db from "../../components/firebaseInit";
import firebase from "firebase/app";
import { encryptMessage, decryptMessage, generateKey } from "../../security/AES";

export const messageMixin = {
  data() {
    return {
      // Part of the Message Component.
      messages: [],
      messagesPatient: [],
      allMessages: [],
      currentUser: "",
      isStaff: null,
      showInfo: false
    };
  },
  methods: {
    /*
        This method gets all the messages on page load (after decrypting them).

        Part of the Message Component.
    */
    getAllMessages() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .orderBy("datetime", "asc")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            var msgDate = doc.data().datetime.toDate();
            var msg = decryptMessage(
              doc.data().content,
              this.$route.params.appointmentID
            );
            const data = {
              msgKey: doc.data().content,
              content: msg,
              datetime: msgDate,
              isPatient: doc.data().isPatient,
              seenByPatient: doc.data().seenByPatient,
              timestamp: doc.data().datetime
            };

            this.allMessages.push(data);
            this.messages = this.allMessages;
          });
        });
    },
    /*
        This method set all messages sent by the user(Patient)
        to seen by the Staff Member.

        Part of the Message Component.
    */
    clearNot() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .orderBy("datetime", "asc")
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(doc => {
            if (doc.data().seenByStaff == false) {
              doc.ref
                .update({
                  seenByStaff: true
                })
                .then(() => {
                  console.log("Updated notification count");
                });
            }
          });
        });
    },
    /*
        This method listens for any changes in the messages collection
        and gets if any new messages have been sent (after decrypting them)

        Part of the Message Component.
    */
    fetchData() {
      db.collection("appointments")
        .doc(this.$route.params.appointmentID)
        .collection("messages")
        .orderBy("datetime", "asc")
        .onSnapshot(snapshot => {
          snapshot.docChanges().forEach(change => {
            // get the newest message
            if (change.type === "added") {
              var msg = decryptMessage(
                change.doc.data().content,
                this.$route.params.appointmentID
              );
              const data = {
                content: msg,
                datetime: change.doc.data().datetime.toDate(),
                isPatient: change.doc.data().isPatient,
                seenByPatient: change.doc.data().seenByPatient,
                timestamp: change.doc.data().datetime
              };
              this.messages.push(data);
              this.clearNot();
            }
            // if the collection has been changed mark as seen
            if (change.type === "modified") {
              for (var i = 0; i < this.messages.length; i++) {
                if (
                  this.messages[i].timestamp.toString() ==
                  change.doc.data().datetime.toString()
                ) {
                  if (
                    this.messages[i].seenByPatient !=
                    change.doc.data().seenByPatient
                  ) {
                    this.messages[
                      i
                    ].seenByPatient = change.doc.data().seenByPatient;
                    this.messages.push();
                  }
                }
              }
              console.log("Message modified!");
            }
          });
          this.scrollToBottom();
        });
    },
    /*
        This method sends(adds) the specified message to the firestore,
        after encrypting it.

        Part of the Message Component.
    */
    sendMessage() {
      var checkMessage = document.getElementById("textArea").value.trim();
      if (checkMessage.length != 0 && checkMessage != "") {
        var message = "";
        message = document.getElementById("textArea").value;
        var encryptedMessage = encryptMessage(
          message,
          this.$route.params.appointmentID
        );
        db.collection("appointments")
          .doc(this.$route.params.appointmentID)
          .collection("messages")
          .add({
            content: encryptedMessage,
            datetime: firebase.firestore.Timestamp.fromDate(
              new Date(Date.now())
            ),
            isPatient: false,
            seenByStaff: true,
            seenByPatient: false
          })
          .then(function () {
            document.getElementById("textArea").value = "";
            message = null;
            document.getElementById("textArea").click();
            console.log("Document successfully written!");
          })
          .catch(function (error) {
            console.error("Error writing document: ", error);
          });
      }
    },
    /*
        This method automatically scrolls the message component to
        the bottom or newest message so it is visible to the user.

        Part of the Message Component.
    */
    scrollToBottom() {
      var elmnt = document.getElementById("messages");
      elmnt.scrollTop = elmnt.scrollHeight;
    }
  }
};
