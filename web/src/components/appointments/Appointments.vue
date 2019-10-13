<template>
  <div id="view-appointment">
    <div class="container" id="main">
      <table class="collection with-header">
        <thead class="collection-header">
          <h3>
            <b>{{pastString}} Appointments</b>
          </h3>
          <div>
            <div style="padding:20px;display:flex;" class="row">
              <div class="input-field col s12">
                <span style="color:black !important">
                  <b>Sort by:</b>
                </span>
                <select
                  id="select"
                  @change="sortByOrder"
                  class="browser-default"
                  style="color:black; min-width: 185px"
                >
                  <option value="Date" selected>Date in ascending order</option>
                  <option value="Date desc">Date in descending order</option>
                </select>
              </div>
              <div class="input-field col s12" style="padding:15px;">
                <input
                  required
                  id="datePicker"
                  value
                  type="date"
                  min="2019-01-01"
                  style="text-align:center"
                >
              </div>
              <div>
                <a class="blue-text tooltip" style="margin-top: 45px !important;cursor:pointer">
                  <span class="tooltiptext">Click this calendar icon to sort by specific date</span>
                  <i class="material-icons" @click="sortByDate">calendar_today</i>
                </a>
              </div>
            </div>
            <div style="position:relative; bottom:50px;">
              <div class="input-field col s12" style="width:70%;">
                <span class="blue-text" for>Search By Code</span>
                <input
                  id="searchCode"
                  required
                  @keydown.enter.prevent
                  @keydown.enter="sortByCode"
                  class="file-path validate"
                  type="text"
                >
                <div>
                  <button id="searchBtn" style="margin:5px" @click="sortByCode" class="btn">Search</button>
                  <button id="resetBtn" style="margin:5px" @click="resetTable" class="btn">Reset</button>
                </div>
              </div>
            </div>
          </div>
          <tr style="font-size:1.5em">
            <th>
              <a class="black-text tooltip" style="margin-left: 25px !important;">
                <span class="tooltiptext">Mobile Code</span>
                <i class="material-icons">phonelink_lock</i>
              </a>
            </th>
            <th>
              <a class="black-text tooltip">
                <span class="tooltiptext">Date and Time</span>
                <i class="material-icons">event</i>
              </a>
            </th>
            <th>
              <a class="black-text tooltip">
                <span class="tooltiptext">Location</span>
                <i class="material-icons">location_on</i>
              </a>
            </th>
            <th>
              <a class="black-text tooltip">
                <span class="tooltiptext">Completed Daily Checkups</span>
                <i class="material-icons">done_outline</i>
              </a>
            </th>
            <th></th>
            <th></th>
            <th></th>
            <th></th>
          </tr>
        </thead>

        <tbody class="collection-item">
          <tr v-for="appointment in appointments" v-bind:key="appointment.code">
            <td style="font-size: 20px;">{{appointment.code}}</td>
            <td>{{appointment.datetime.toDate()}}</td>
            <td>{{appointment.location}}</td>
            <template v-for="checkup in dailyCheckups">
              <td
                v-bind:key="checkup.id"
                v-if="checkup.id == appointment.code"
              >{{checkup.count}}/{{checkup.length}}</td>
            </template>
            <td>
              <router-link
                id="viewAppBtn"
                v-bind:to="{name: 'view-appointment', params: {expired:past ,id:appointment.code}}"
              >
                <a class="tooltip">
                  <span class="tooltiptext">View Appointment</span>
                  <i
                    class="material-icons"
                    style="position:relative;text-align:center;"
                  >remove_red_eye</i>
                </a>
              </router-link>
            </td>
            <td v-if="past==false">
              <a id="expireAppBtn" class="tooltip">
                <span class="tooltiptext">Make Appointment Expired</span>
                <i
                  @click="expireAppointment(appointment.code, false)"
                  class="orange-text material-icons"
                  style="position:relative;text-align:center;cursor:pointer;"
                >timer_off</i>
              </a>
            </td>
            <td>
              <a id="deleteAppBtn" class="tooltip">
                <span class="tooltiptext">Delete Appointment</span>
                <i
                  @click="deleteAppointment(appointment.code)"
                  class="red-text material-icons"
                  style="position:relative;text-align:center;cursor:pointer;"
                >delete</i>
              </a>
            </td>
            <td>
              <router-link
                id="msgBtn"
                v-bind:to="{name: 'message', params: {expired: past, appointmentID: appointment.code}}"
              >
                <i
                  class="material-icons left green-text"
                  style="margin-left:5px;font-size:30px;text-align:center"
                >insert_comment</i>

                <span v-if="notifications[ids.indexOf(appointment.code)] != 0">
                  <span
                    v-if="ids.includes(appointment.code) == true"
                    class="new badge"
                  >{{notifications[ids.indexOf(appointment.code)]}}</span>
                </span>
              </router-link>
            </td>
          </tr>
        </tbody>
        <template v-if="past==false">
          <router-link
            id="addAppBtn"
            to="/add-appointment"
            class="btn green"
            style="margin:20px"
          >Add Appointment</router-link>
        </template>
        <template v-else>
          <router-link
            to="/add-appointment"
            class="btn green"
            style="margin:20px"
            disabled
          >Add Appointment</router-link>
        </template>
      </table>
    </div>
  </div>
</template>

<script>
import { viewAppointmentsMixin } from "../../mixins/appointmentsMixin/view_appointmentsMixin.js";
export default {
  name: "view-appointments",
  props: ["past"],
  mixins: [viewAppointmentsMixin],
  created() {
    this.setDate();
    this.loadUser();
    this.getAppointments("asc");
  }
};
</script>

<style scoped>
table {
  width: 100%;
  min-width: 50%;
  background: white; 
  height: auto;
}
h3 {
  padding: 20px;
}
#main {
  width: 100%;
}
td,
th {
  padding: 10px !important;
}
</style>
