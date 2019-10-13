<template>
  <div class="mainContainer" id="edit-dailycheckups">
    <h3>Edit Daily Check-ups</h3>

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
      <form @submit.prevent="updateDailyCheckups" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <p>Number of Days Before Test:</p>
            <input type="number" min="0" v-model="daysBeforeTest" required>
          </div>
        </div>

        <button id="add" @click="addInstruction" class="btn green">Add instruction</button>
        <div class="row">
          <div
            v-for="instruction in instructions"
            v-bind:key="instruction"
            class="input-field col s12"
          >
            <input type="text" v-model="instruction.value" required>
            <label>Instructions</label>
            <button
              class="btn red"
              @click="deleteAddedInstruction(instructions.indexOf(instruction))"
            >remove instruction</button>
          </div>
        </div>

        <div class="row">
          <div v-for="instr in allInstrArray.length" v-bind:key="instr" class="input-field col s12">
            <span>Instruction</span>
            <input type="text" v-model="allInstrArray[instr - 1]" required>
            <button
              id="delete"
              @click="deleteInstructionEdit(instr -1)"
              class="btn red"
            >remove instruction</button>
          </div>
        </div>

        <button id="submit" type="submit" class="btn">Submit</button>
        <router-link
          v-bind:to="{name: 'view-dailycheckups-info', params: {test_id:test_id, daily_id:this.code}}"
        >
          <button id="cancelEdit" class="btn grey">Cancel</button>
        </router-link>
      </form>
    </div>
  </div>
</template>

<script>
import { dailycheckupMixin } from "../../../mixins/dailycheckupsMixin/dailycheckupMixin";

export default {
  name: "edit-dailycheckups",
  mixins: [dailycheckupMixin],
  data() {
    return {
      code: null,
      test_id: this.$route.params.test_id,
      daily_id: this.$route.params.daily_id
    };
  },
  created() {
    this.code = this.$route.params.daily_id;
    this.getCheckups();
  }
};
</script>


