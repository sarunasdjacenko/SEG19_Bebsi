<template>
  <div>
    <view_app v-bind:past="past"/>
  </div>
</template>
<script>
import view_app from "./Appointments";

export default {
  name: "past-appointments",
  components: {
    view_app
  },
  data() {
    return {
      past: true
    };
  }
};
</script>