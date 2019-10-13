<template>
  <div id="view-dailycheckups">
    <ul class="collection with-header">
      <li class="collection-header">
        <div calss="container" style="width:100%;height:100%">
          <table calss="collection with-header " style="background: white;width:100%;height:auto">
            <thead calss="collection-header">
              <h4>Daily Check-ups</h4>
              <tr style="font-size:1.5em">
                <th>Id</th>
                <th>Days Before Test</th>
                <th>Description</th>
              </tr>
            </thead>
            <tbody
              v-for="dailyCheckup in dailyCheckups"
              v-bind:key="dailyCheckup.id"
              class="collection-item"
            >
              <tr>
                <td>{{dailyCheckup.id}}</td>
                <td>{{dailyCheckup.daysBeforeTest}}</td>
                <td>
                  <router-link
                    v-bind:to="{name: 'view-dailycheckups-info', params: {test_id: testID, daily_id:dailyCheckup.id}}"
                    class="btn blue"
                  >Show</router-link>
                </td>
              </tr>
            </tbody>
            <br>
            <router-link v-bind:to="{name: 'new-dailycheckups', params: {test_id: testID}}">
              <button
                class="btn green"
                style="position:relative;text-align:center;"
              >Add DailyCheckUps</button>
            </router-link>
            <router-link to="/view-tests">
              <button id="GoBackTest" class="btn grey" style="margin:10px;">Back</button>
            </router-link>
          </table>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import { dailycheckupMixin } from "../../../mixins/dailycheckupsMixin/dailycheckupMixin";
export default {
  name: "view-dailycheckups",
  mixins: [dailycheckupMixin],
  data() {
    return {
      dailyCheckups: [],
      testID: this.$route.params.test_id
    };
  },
  created() {
    this.getCheckup();
  }
};
</script>


