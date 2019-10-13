<template>
  <div class="mainContainer" id="new-dailycheckups">
    <h3>Add Daily Check-ups</h3>

    <div class="row">
      <div class="col s12">
        <div class="card-panel light-blue">
          <span class="card-title white-text">
            <i class="small material-icons">info_outline</i>Info
          </span>
          <p class="white-text">
            Enter a number of days before the test that this checkup applies.
            <br>
            <br>You can add and remove instructions as needed.
          </p>
        </div>
      </div>
      <form @submit.prevent="saveDailyCheckups" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <input type="number" min="0" v-model="daysBeforeTest" required>
            <label>Number of Days Before Test:</label>
          </div>
        </div>

        <button id="add" @click="addInstruction" class="btn green">new instruction</button>
        <div class="row">
          <div
            v-for="instruction in instructions"
            v-bind:key="instruction"
            class="input-field col s12"
          >
            <input type="text" v-model="instruction.value" required>
            <label>Instructions</label>
            <button
              id="delete"
              class="btn red"
              @click="deleteInstruction(instructions.indexOf(instruction))"
            >remove instruction</button>
          </div>
        </div>

        <button id="submit" type="submit" class="btn">Submit</button>
        <router-link
          v-bind:to="{name: 'view-dailycheckups', params: {test_id: this.$route.params.test_id}}"
        >
          <button id="CancelAdd" class="btn grey">Cancel</button>
        </router-link>
      </form>
    </div>
  </div>
</template>

<script>
import { dailycheckupMixin } from "../../../mixins/dailycheckupsMixin/dailycheckupMixin";

export default {
  name: "new-dailycheckups",
  mixins: [dailycheckupMixin],
  data() {
    return {
      test_id: this.$route.params.test_id,
      daily_id: this.$route.params.daily_id
    };
  }
};
</script>

<style>
label {
  color: #2196f3 !important;
}
</style>



