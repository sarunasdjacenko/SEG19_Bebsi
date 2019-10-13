<template>
  <div>
    <div class="containerChat" id="top">
      <span class="card-title blue-text">
        <i
          @click="(showInfo ? showInfo=false : showInfo=true )"
          class="small material-icons"
          style="cursor:pointer;"
        >info_outline</i>Info
      </span>
      <div class="row" v-if="showInfo">
        <div class="col s12">
          <div class="card-panel light-blue white-text" style="height: 100px;">
            Please be aware that pressing 'Enter' will only make a new line and not send the message!
            <br>Click the 'Send Button' to send a message.
            <br>To scroll to the bottom click on the textbox.
          </div>
        </div>
      </div>
      <div id="messages" tag="msg">
        <ul>
          <li v-for="message in messages" v-bind:key="message.msgKey">
            <div
              v-if="message.isPatient == false"
              class="containerChat"
              style="max-width:100%;overflow:hidden;background-color:#d0ecff"
            >
              <p>{{message.content}}</p>
              <span class="time-left">{{message.datetime}}</span>
              <div>
                <i class="material-icons right">accessibility_new</i>
                <i v-if="message.seenByPatient == false" class="material-icons time-right">done</i>
                <i v-else class="material-icons blue-text right">done_all</i>
              </div>
            </div>
            <div
              v-if="message.isPatient == true"
              class="containerChat darker"
              style="max-width:100%;overflow:hidden;"
            >
              <p>{{message.content}}</p>
              <span class="time-left">{{message.datetime}}</span>
              <label class="right">Patient</label>
            </div>
          </li>
          <li v-if="messages.length == 0">
            <div class="containerChat" style="max-width:100%;">
              <p>Say hello to the patient 👋</p>
            </div>
          </li>
        </ul>
      </div>
      <form @submit.prevent="sendMessage">
        <div class="row">
          <div class="input-field col s12">
            <div id="foot" class="valign-wrapper">
              <template v-if="this.$route.params.expired == false">
                <textarea
                  @click="scrollToBottom"
                  style="width:30%;height:80px;resize: none;"
                  id="textArea"
                  required
                ></textarea>
                <button
                  id="sendMessage"
                  type="submit"
                  class="btn btn-large"
                  style="margin-left:5px;padding-right:15px"
                >
                  <i class="material-icons left">send</i>
                </button>
              </template>
            </div>
          </div>
        </div>
      </form>

      <template v-if="this.$route.params.expired == false">
        <router-link
          id="currentApp"
          to="/view-appointments"
          class="btn grey"
          style="margin-bottom:10px;"
        >Go Back</router-link>
      </template>
      <template v-else>
        <router-link
          id="pastApp"
          to="/past-appointments"
          class="btn grey"
          style="margin-bottom:10px;"
        >Go Back</router-link>
      </template>
    </div>
  </div>
</template>
<script>
import { messageMixin } from "../../mixins/messagesMixin/messageMixin";
export default {
  name: "message",
  mixins: [messageMixin],
  created() {
    this.clearNot();
    this.fetchData();
    this.getAllMessages();
  }
};
</script>

<style>
#top {
  height: 100%;
  width: 100%;
}
#messages {
  max-height: 50vh;
  overflow-y: auto;
}

p {
  white-space: pre;
}

.containerChat {
  word-wrap: break-word;
  border: 2px solid #dedede;
  background-color: white;
  border-radius: 5px;
  padding: 10px;
  margin: 10px 0;
  width: 100%;
  overflow-x: hidden;
  max-height: 100vh;
}

#textArea {
  word-wrap: break-word;
  white-space: normal;
  overflow: hidden;
  background-color: white;
  clear: both;
}

.darker {
  border-color: #ccc;
  background-color: #e7e7e7;
}

.containerChat::after {
  content: "";
  clear: both;
  display: table;
}

.time-right {
  float: right;
  color: #aaa;
}

.time-left {
  float: left;
  color: #999;
}
</style>
