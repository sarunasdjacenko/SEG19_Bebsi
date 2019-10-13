// This mixin will be used for any functionality that is shared between the test components.
// To make use of the functionality in this file import { testMixin } from '(this location)'
// and then add 'mixins: [testMixin]' just before the data of the component.

import textEditor from '../../components/shared/TextEditor'

export const testMixin = {
    data() {
        return {
            // shared data for tests
            title: '',
            department: '',
            imagesForEditor: [],
            htmlForEditor: '',
            dataLoaded: false
        }
    },

    // make the text editor available to test components
    components: {
        textEditor
    },


    methods: {
    },
    mounted() {
        // initialise collapsible component
        $(document).ready(function () {
            $('.collapsible').collapsible()
        })
    }
}