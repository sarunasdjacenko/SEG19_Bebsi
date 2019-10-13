<template>
  <div class="mainContainer" id="edit-appointment">
    <h3>Edit Appointment</h3>
    <div class="row">
      <form @submit.prevent="updateAppointment" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <p>Mobile Code:</p>
            <input type="text" v-model="code" disabled required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Date</p>
            <input type="date" min="2019-01-01" class="datepicker" v-model="date" required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Time</p>
            <input type="time" class="timepicker" v-model="time" required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Location:</p>
            <input type="text" v-model="location" required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Contact Number:</p>
            <input type="tel" v-model="contactNumber" required>
          </div>
        </div>

        <div class="row">
          <div class="input-field col s12">
            <p>Change Referenced Staff:</p>
            <select
              id="selectRefStaff"
              class="browser-default"
              style="color:black"
              v-model="staffMember"
            >
              <option v-for="user in users" v-bind:key="user.Ucode" :value="user">{{user.name}}</option>
            </select>
          </div>
        </div>

        <button id="submitEditAppBtn" type="submit" class="btn">Submit</button>

        <router-link
          id="cancelAppEditBtn"
          v-bind:to="{name: 'view-appointment', params: {expired: expired, id: router}}"
          class="btn grey"
        >Cancel</router-link>
      </form>
    </div>
    <br>
  </div>
</template>

<script>
import { appointmentMixin } from "../../mixins/appointmentsMixin/appointmentMixin";
export default {
  name: "edit-appointment",
  mixins: [appointmentMixin],
  created() {
    // Load all data
    this.loadFields();
    // Gets all the information from the users collection
    this.getAllUsers();
  }
};
</script>
<style scoped>
p {
  color: #2196f3;
}
h3 {
  font-weight: bold;
  margin-left: 20px;
}
</style>
