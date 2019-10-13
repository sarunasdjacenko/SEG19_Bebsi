// This mixin will be used for any functionality that is shared between the lists components.
// To make use of the functionality in this file import { listsMixin } from '(this location)'
// and then add 'mixins: [listsMixin]' just before the data of the component.

import db from "../../components/firebaseInit";

export const listsMixin = {
    data() {
        return {
            lists: [],
            maps: [],
            title: null,
            prepCardID: null,
            allMaps: [], // newly added maps
            allData: [], // maps from database
            category: "categoryList",
            test_id: this.$route.params.test_id,
            List: this.$route.params.contents
        };
    },
    methods: {
        createPrepLists() {
            db.collection("tests")
                .doc(this.$route.params.test_id)
                .collection("prepCards")
                .where("type", "==", "categoryList")
                .get()
                .then(querySnapshot => {
                    querySnapshot.forEach(doc => {
                        const data = {
                            id: doc.id, // the document id in the database
                            title: doc.data().title
                        };
                        this.lists.push(data);
                    });
                })
        },
        createPrepList() {
            db.collection("tests")
                .doc(this.$route.params.test_id)
                .collection("prepCards")
                .doc(this.$route.params.contents)
                .get()
                .then(doc => {
                    // gets all the maps and pushes them seperately into an array
                    doc.data().maps.forEach(map => {
                        this.maps.push(map);
                    })
                    this.title = doc.data().title
                });
        },
        // deletes the list from the database as well as its card
        deleteList() {
            if (confirm("Are you sure?")) {
                db.collection("tests")
                    .doc(this.$route.params.test_id)
                    .collection("prepCards")
                    .doc(this.$route.params.contents)
                    .delete()
                    .then(doc => {
                        alert('List deleted!')
                        this.$router.push({
                            name: "view-prep-lists",
                            params: { test_id: this.$route.params.test_id }
                        });
                    });

            }
        },
        createEditPrepList() {
            db.collection("tests")
                .doc(this.$route.params.test_id)
                .collection("prepCards")
                .doc(this.$route.params.contents)
                .get()
                .then(doc => {
                    doc.data().maps.forEach(map => {
                        this.allData.push(map);
                    });
                    this.title = doc.data().title
                });
            // gets the title of the list
        },
        createPrepCard() {
            db.collection("tests")
                .doc(this.$route.params.test_id)
                .collection("prepCards")
                .add({
                    title: this.title,
                    contents: this.title,
                    type: this.category,
                    maps: this.allMaps
                })
                // reroutes to all the lists
                .then(docRef => {
                    alert("List added!");
                    this.$router.push({
                        name: "view-prep-lists",
                        params: { test_id: this.$route.params.test_id }
                    });
                })
                .catch(error => console.log(err));
        },
        // adds a new map to the array
        addMap() {
            let data = new Object();
            data.name = "";
            data.description = "";
            data.list = [];
            this.allMaps.push(data);
        },
        // adds an item to the list of the old map
        addToOldList(newData) {
            const data = "";
            newData.list.push(data);
        },
        // adds an item to the list of the new map
        addToList(map) {
            const data = "";
            map.list.push(data);
        },
        // deletes an item from the list of the old map
        deleteFromOldList(newData, index) {
            newData.list.splice(index, 1);
        },
        // deletes an item from the list of the new map
        deleteFromList(map, index) {
            map.list.splice(index, 1);
        },
        // deletes newly added map
        deleteMap(index) {
            this.allMaps.splice(index, 1);
        },
        // deletes a map from the array in the database
        deleteOldMap(index) {
            this.allData.splice(index, 1);
        },
        updatePrepList() {
            if (this.allMaps.length > 0) {
                // adds the 2 arrays together to form the new set of maps and adds the new array to the database
                var theMaps = this.allData.concat(this.allMaps);
                //for (l in theMaps) alert("h")
                db.collection("tests")
                    .doc(this.$route.params.test_id)
                    .collection("prepCards")
                    .doc(this.$route.params.contents)
                    .set({
                        maps: theMaps,
                        title: this.title,
                        contents: this.title,
                        type: "categoryList"
                    }).then(() => {
                        // route back to list viewing page
                        alert("List edited!");
                        this.$router.push({
                            name: "view-prep-list",
                            params: {
                                test_id: this.$route.params.test_id,
                                contents: this.$route.params.contents
                            }
                        });
                    });
            } else {
                db.collection("tests")
                    .doc(this.$route.params.test_id)
                    .collection("prepCards")
                    .doc(this.$route.params.contents)
                    .set({
                        maps: this.allData,
                        title: this.title,
                        contents: this.title,
                        type: "categoryList"
                    }).then(() => {
                        // route back to list viewing page
                        alert("List edited!");
                        this.$router.push({
                            name: "view-prep-list",
                            params: {
                                test_id: this.$route.params.test_id,
                                contents: this.$route.params.contents
                            }
                        });
                    });
            }
        },
    }
}