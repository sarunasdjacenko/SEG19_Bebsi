// This mixin will be used for any queries that are shared between the article components.
// To make use of the functionality in this file import { articleQueryMixin } from '(this location)'
// and then add 'mixins: [articleQueryMixin]' just before the data of the component.

import db from '../../components/firebaseInit'

export const articleQueryMixin = {

    methods: {

        // get all articles
        getArticles() {
            db.collection('tests')
                .doc(this.$route.params.test_id)
                .collection('prepCards')
                .get()
                .then(querySnapshot => {
                    querySnapshot.forEach(doc => {
                        if (doc.data().type === 'article') {
                            const article = {
                                id: doc.id,
                                title: doc.data().title
                            }
                            this.articles.push(article)
                        }
                    })
                })
        },


        // get an article by its id
        getArticle() {
            db.collection("tests")
                .doc(this.$route.params.test_id)
                .collection('prepCards')
                .doc(this.$route.params.article_id)
                .get()
                .then(doc => {
                    if (doc.exists) {
                        this.title = doc.data().title
                        this.htmlForEditor = doc.data().description
                        this.imagesForEditor = doc.data().editorImages
                        this.dataLoaded = true
                    }
                })
        },


        // delete article by id
        deleteArticle(id) {
            // delete the article from prepcards
            db.collection('tests')
                .doc(this.$route.params.test_id)
                .collection('prepCards')
                .doc(id)
                .delete()
                .then(() => {
                    this.articles.splice(id, 1)
                    console.log("Document successfully deleted!")
                    alert(`Successfully deleted Article`)
                })
                .catch((error) => {
                    console.error("Error removing document: ", error)
                    alert(`There was an error: ${error}`)
                })
        },


        // save the new article to the prepCards collection
        saveArticle() {
            // run the editors save method
            this.$refs.textEditor.saveEditorData()
            db.collection("tests")
                .doc(this.$route.params.test_id)
                .collection("prepCards")
                .add({
                    title: this.title,
                    type: 'article',
                    description: (this.$refs.textEditor.htmlForEditor === undefined ? '' : this.$refs.textEditor.htmlForEditor),
                    editorImages: this.$refs.textEditor.images
                })
                .then(docRef => {
                    console.log("Document written with ID: ", docRef.id)
                    alert(`New article: ` + this.title + ` saved!`)
                })
                .catch(error => {
                    console.error("Error adding document: ", error)
                    return // dont leave the page if save fails
                })
            // return to articles page
            this.$router.push({ name: 'view-articles', params: { test_id: this.test_id, title: this.test_title } })
        },


        // update an existing article in the database
        updateArticle() {
            // run the editors save method
            this.$refs.textEditor.saveEditorData()
            // save the document
            db.collection('tests')
                .doc(this.test_id)
                .collection('prepCards')
                .doc(this.article_id)
                .update({
                    title: this.title,
                    description: (this.$refs.textEditor.htmlForEditor === undefined ? '' : this.$refs.textEditor.htmlForEditor),
                    editorImages: this.$refs.textEditor.images
                })
                .then(docRef => {
                    console.log("Document saved");
                    alert(`Edit to: ` + this.title + ` saved!`)
                })
                .catch(error => {
                    console.error("Error adding document: ", error)
                    return // dont leave the page if save fails
                })
            // return to tests page
            this.$router.push({ name: 'view-articles', params: { test_id: this.test_id, title: this.test_title } })
        }
    }
}