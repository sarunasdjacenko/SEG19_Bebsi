<template>
  <div class="mainContainer" id="new-appointment">
    <div id="loader">
      <div id="el" class="preloader-wrapper big active">
        <div class="spinner-layer spinner-blue-only">
          <div class="circle-clipper left">
            <div class="circle"></div>
          </div>
          <div class="gap-patch">
            <div class="circle"></div>
          </div>
          <div class="circle-clipper right">
            <div class="circle"></div>
          </div>
        </div>
      </div>
      <label style="font-size:25px">Generating Code... Please wait!</label>
    </div>
    <div id="mainScreen">
      <h3>New Appointment</h3>
      <div class="row">
        <form @submit.prevent="saveAppointment" class="col s12">
          <div class="row">
            <div class="input-field col s12">
              <input type="date" min="2019-01-01" class="datepicker" v-model="date" required>
              <label>Date</label>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <input type="time" class="timepicker" v-model="time" required>
              <label>Time</label>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <span>Location</span>
              <input type="text" v-model="location" required>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <span>Contact Number</span>
              <input type="tel" v-model="contactNumber" required>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <span>Staff Member</span>
              <input type="text" v-model="currentUser" disabled required>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <span>Choose Test</span>
              <select id="selectTest" class="browser-default" style="color:black" v-model="testID">
                <option v-for="test in tests" v-bind:key="test.testID" :value="test">{{test.title}}</option>
              </select>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <span>Generated Mobile Code</span>
              <input type="text" v-model="code" disabled required>
            </div>
          </div>
          <button id="submitAddAppBtn" type="submit" class="btn">Submit</button>
          <router-link id="cancelAddAppBtn" to="/view-appointments" class="btn grey">Cancel</router-link>
        </form>
      </div>
    </div>
  </div>
</template>


<script>
import { appointmentMixin } from "../../mixins/appointmentsMixin/appointmentMixin.js";

export default {
  name: "add-appointment",
  mixins: [appointmentMixin],
  created() {
    this.checkIfCodeExists();
    this.getDocId();
    // Get all the information from tests collection
    this.getTests();
  }
};
</script>

<style>
label {
  color: #2196f3 !important;
}

span {
  color: #2196f3;
}
</style>
