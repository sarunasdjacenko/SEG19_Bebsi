// This mixin will be used for any functionality that is shared between the recipe components.
// To make use of the functionality in this file import { recipeMixin } from '(this location)'
// and then add 'mixins: [recipeMixin]' just before the data of the component.

import imageUploader from '../../components/shared/ImageUploader'

export const recipeMixin = {
    data() {
        return {
            // shared data for recipes
            title: null,
            subtitle: null,
            imageURL: null,
            ingredients: [],
            instructions: [],
            recipeType: null,
            note: null,
            externalURL: null,
            labels: [],
            // possible types for a recipe
            recipeTypes: [
                "salad",
                "soup",
                "vegetable",
                "roast",
                "stew",
                "pizza",
                "sandwich",
                "wrap",
                "pie",
                "fish",
                "beef",
                "chicken",
                "curry",
                "eggs"
            ]
        }
    },

    components: {
        imageUploader
    },


    methods: {
        // functions to edit the ingredients and instructions 
        addInstruction() {
            this.instructions.push('')
        },
        deleteInstruction(index) {
            this.instructions.splice(index, 1)
        },
        addIngredient() {
            this.ingredients.push('')
        },
        deleteIngredient(index) {
            this.ingredients.splice(index, 1)
        },
        // get array of tag strings from chips
        getChips() {
            var arr = M.Chips.getInstance($('.chips')).chipsData
            var chips = []
            if (arr.length !== 0) {
                for (var i = 0; i < arr.length; i++) {
                    chips.push(arr[i].tag)
                }
            }
            return (chips.length === 0 ? null : chips)
        },
        // load current chips into the input area
        loadChips() {
            if (this.labels !== null) {
                var instance = M.Chips.getInstance($('.chips'))
                for (var i = 0; i < this.labels.length; i++) {
                    instance.addChip({
                        tag: this.labels[i]
                    })
                }
            }
        },

        // make sure the recipe has the required fields
        validRecipe() {
            if (!((this.externalURL !== null && this.externalURL !== '') || (this.ingredients.length > 0 && this.instructions.length > 0))) {
                alert('Please provide a recipe link or a method and ingredients')
                return false
            } else {
                return true
            }
        }
    },
    mounted() {
        // initialise materialize components 
        $('.chips-placeholder').chips({
            placeholder: 'Enter a tag'
        })
        $(document).ready(function () {
            $('select').formSelect()
        })
    }
}