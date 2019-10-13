<template>
  <div class="mainContainer" id="new-list">
    <h3>New List View</h3>
    <div class="row">
      <ul>
        <li>
          <div class="col s12">
            <div class="card-panel light-blue">
              <span class="card-title white-text">
                <i class="small material-icons">info_outline</i>Info
              </span>
              <p class="white-text">
                The list title will be displayed in the preparation card and as the title on that list's screen
                <br>
                <br>Clicking on the NEW LIST button will create a new sublist inside the list's screen. This will contain a name, description and a list of items
                <br>
                <br>Click on the NEW ITEM button to add items to the list of items.
              </p>
            </div>
          </div>
        </li>
      </ul>
    </div>
    <div class="row">
      <div class="fixed-action-btn">
        <router-link
          v-bind:to="{name: 'view-prep-lists', params: {test_id: this.$route.params.test_id}}"
          class="btn-floating btn-large black"
        >
          <i class="material-icons">arrow_back</i>
        </router-link>
      </div>
      <form @submit.prevent="createPrepCard" class="col s12">
        <div class="row">
          <div class="input-field col s12">
            <span id="title">Title*</span>
            <input type="text" v-model="title" required>
          </div>
        </div>
        <div>
          <!-- adds a new map to be added to the database -->
          <button id="newListButton" @click="addMap" class="btn green">new List</button>
          <div v-for="map in allMaps" v-bind:key="map.id" class="input-field col s12">
            <span id="title">Name*</span>
            <input type="text" v-model="map.name" required>
            <span id="title">Description</span>
            <input type="text" v-model="map.description">
            <!-- adds an item to the list in the new map -->
            <button @click="addToList(map)" class="btn green">new item</button>
            <div v-for="item in map.list.length" v-bind:key="item" class="input-field col s12">
              <span id="title">Item</span>
              <input type="text" v-model="map.list[item - 1]" required>
              <!-- remove item from the list in the new map -->
              <button
                type="button"
                @click="deleteFromList(map, item - 1)"
                class="btn red"
              >remove item</button>
            </div>
            <!-- remove newly added map -->
            <button
              type="button"
              @click="deleteMap(allMaps.indexOf(map))"
              class="btn red"
            >remove List</button>
          </div>
        </div>
        <div style="margin-top:10px">
          <button id="submitButton" type="submit" class="btn">Submit</button>
          <!-- cancel button -->
          <router-link
            id="cancelButton"
            v-bind:to="{name: 'view-prep-lists', params: {test_id: this.$route.params.test_id}}"
            class="btn grey"
          >Cancel</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { listsMixin } from "../../../mixins/listsMixin/listsMixin.js";
export default {
  name: "new-list",
  mixins: [listsMixin]
};
</script>
<style scoped>
#title {
  color: #2196f3;
}
#addBtn {
  margin: 15px;
}
#removeBtn {
  margin-right: 10px;
  margin-left: 10px;
}
</style>