// This mixin will be used for queries that are shared between the recipe components.
// To make use of the functionality in this file import { recipeQueryMixin } from '(this location)'
// and then add 'mixins: [recipeQueryMixin]' just before the data of the component.

import db from '../../components/firebaseInit'

export const recipeQueryMixin = {
    data() {
        return {
        }
    },
    methods: {
        // get all recipes 
        getRecipes() {
            db.collection('tests')
                .doc(this.$route.params.test_id)
                .collection('prepCards')
                .get()
                .then(querySnapshot => {
                    querySnapshot.forEach(doc => {
                        if (doc.data().type === 'recipe') {
                            const data = {
                                id: doc.id,
                                title: doc.data().title
                            }
                            this.recipes.push(data)
                        }
                    })
                })
        },

        // get a single recipe by its id
        getRecipe(test_id, recipe_id) {
            db.collection("tests")
                .doc(test_id)
                .collection("prepCards")
                .doc(recipe_id)
                .get()
                .then(doc => {
                    if (doc.exists) {
                        this.title = doc.data().title,
                            this.subtitle = doc.data().subtitle,
                            this.imageURL = doc.data().backgroundImage,
                            this.labels = doc.data().labels,
                            this.externalURL = doc.data().externalURL,
                            this.ingredients = doc.data().ingredients,
                            this.instructions = doc.data().method,
                            this.note = doc.data().note,
                            this.recipeType = doc.data().recipeType
                        // wait for chips to be initialised
                        this.$nextTick(() => this.loadChips())
                    }
                })
        },

        // Add a new recipe to the database
        saveRecipe() {
            // only save if recipe is valid
            if (this.validRecipe()) {
                // get correctly formatted arrays before saving
                var labels = this.getChips()
                db.collection('tests')
                    .doc(this.$route.params.test_id)
                    .collection('prepCards')
                    .add({
                        type: 'recipe',
                        title: this.title,
                        subtitle: this.subtitle,
                        backgroundImage: this.imageURL,
                        ingredients: this.ingredients,
                        method: this.instructions,
                        labels: labels,
                        note: this.note,
                        recipeType: this.recipeType,
                        externalURL: this.externalURL
                    })
                    .then(docRef => {
                        this.$router.push({ name: 'view-recipes', params: { test_id: this.$route.params.test_id } })
                        alert('Recipe: ' + this.title + ' saved!')
                    })
                    .catch(error => console.log(err))
            }
        },

        // remove the recipe from the database
        deleteRecipe() {
            if (confirm('Are you sure?')) {
                db.collection('tests')
                    .doc(this.$route.params.test_id)
                    .collection('prepCards')
                    .doc(this.$route.params.recipe_id)
                    .get()
                    .then(doc => {
                        if (doc.exists) {
                            doc.ref.delete()
                        }
                        this.$router.push({ name: 'view-recipes', params: { test_id: this.$route.params.test_id } })
                    })
            }
        },

        // update the information for a recipe
        updateRecipe() {
            // only save if recipe is valid
            if (this.validRecipe()) {
                // get correctly formatted arrays before saving
                var labels = this.getChips()
                db.collection("tests")
                    .doc(this.$route.params.test_id)
                    .collection("prepCards")
                    .doc(this.$route.params.recipe_id)
                    .update({
                        title: this.title,
                        subtitle: this.subtitle,
                        method: this.instructions,
                        ingredients: this.ingredients,
                        note: this.note,
                        labels: labels,
                        backgroundImage: this.imageURL,
                        recipeType: this.recipeType,
                        externalURL: this.externalURL
                    })
                    .then(() => {
                        this.$router.push({
                            name: "view-recipes",
                            params: { test_id: this.$route.params.test_id }
                        })
                    })
            }
        }
    }
}