<template>
  <div id="view-prep-list">
    <ul class="collection with-header">
      <li class="collection-header">
        <!-- title of the list -->
        <h4>{{title}}:</h4>
        <!-- route to all the lists -->
        <router-link
          id="backButton"
          v-bind:to="{name: 'view-prep-lists', params: {test_id: test_id}}"
          class="btn grey"
        >Back</router-link>
        <!-- edit the list -->
        <router-link
          id="editButton"
          v-bind:to="{name: 'edit-prep-list', params: {test_id: test_id, contents: this.$route.params.contents}}"
          class="btn green"
        >Edit</router-link>
        <button @click="deleteList" id="deleteButton" class="btn red">Delete</button>
      </li>
      <li class="collection-item">
        <b>
          <h5>Lists:</h5>
        </b>
        <!-- shows all the maps in the database -->
        <div v-for="map in maps" v-bind:key="map.id">
          <li class="collection-item">
            <h6>
              <B>Name:</B>
              {{map.name}}
            </h6>
          </li>
          <ol>
            <li v-for="item in map.list" v-bind:key="item">{{item}}</li>
          </ol>
          <li v-if="map.description" class="collection-item">
            <B>Description:</B>
            {{map.description}}
          </li>
        </div>
      </li>
    </ul>
    <div class="fixed-action-btn"></div>
  </div>
</template>

<script>
import { listsMixin } from "../../../mixins/listsMixin/listsMixin.js";
export default {
  name: "view-prep-list",
  mixins: [listsMixin],
  created() {
    this.createPrepList();
  }
};
</script>