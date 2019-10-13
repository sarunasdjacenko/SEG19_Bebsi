// This mixin will be used for any functionality that is shared between the article components.
// To make use of the functionality in this file import { articleMixin } from '(this location)'
// and then add 'mixins: [articleMixin]' just before the data of the component.

import textEditor from '../../components/shared/TextEditor'

export const articleMixin = {
    data() {
        return {
            // shared data for articles
            title: '',
            article_id: this.$route.params.article_id,
            test_id: this.$route.params.test_id,
            test_title: this.$route.params.test_title,
            imagesForEditor: [],
            htmlForEditor: '',
            dataLoaded: false,
            test_id: this.$route.params.test_id,
            test_title: this.$route.params.test_title
        }
    },

    // make the text editor available to article components
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