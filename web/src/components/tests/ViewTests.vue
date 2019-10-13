<template>
    <div class="mainContainer" id="view-test">
        <div id="mainScreen">
            <h4 style="font-size:3em;"><b>Tests</b></h4>

            <div class="row">
                <div class="col s12">
                    <div class="card-panel light-blue">
                        <span class="card-title white-text"><i class="small material-icons">info_outline</i>Info</span>
                        <p class="white-text">Click on a test below to reveal editing options.</p>
                    </div>
                </div>
            </div>

            <ul class="collapsible popout">
                <li v-for="test in tests" v-bind:key="test.id">
                    <div class="collapsible-header">
                        <div id="title">{{test.title}}</div>Department: {{test.department}}</div>
                    <div class="collapsible-body">
                        <ul class="collection">
                            <li class="collection-item avatar">
                                <i class="material-icons circle green">create</i>
                                <h5 class="titles">Test description</h5>
                                <router-link 
                                    v-bind:to="{name: 'edit-test-description', params: {test_id: test.id}}" 
                                    class="btn blue secondary-content"
                                >Show/Edit</router-link>
                            </li>
                            <li class="collection-item avatar">
                                <i class="material-icons circle green">done_all</i>
                                <h5 class="titles">Daily check-ups</h5>
                                <router-link 
                                    v-bind:to="{name: 'view-dailycheckups', params: {test_id: test.id}}"
                                    class="btn blue secondary-content"
                                >Show/Edit</router-link>                             
                            </li>
                            <li class="collection-item avatar">
                                <i class="material-icons circle purple">assignment</i>
                                <h5 class="titles">Articles</h5>
                                <router-link 
                                    v-bind:to="{name: 'view-articles', params: {test_id: test.id, test_title: test.title}}"  
                                    class="btn blue secondary-content"
                                >Show/Edit</router-link>
                            </li>
                            <li class="collection-item avatar">
                                <i class="material-icons circle blue">list</i>
                                <h5 class="titles">Lists</h5>
                                <router-link 
                                    v-bind:to="{name: 'view-prep-lists', params: {test_id: test.id}}"
                                    class="btn blue secondary-content"
                                >Show/Edit</router-link>
                            </li>
                            <li class="collection-item avatar">
                                <i class="material-icons circle orange">live_help</i>
                                <h5 class="titles">FAQs</h5>
                                <router-link 
                                    v-bind:to="{name: 'view-prep-faqs', params: {test_id: test.id}}" 
                                    class="btn blue secondary-content"
                                >Show/Edit</router-link>
                            </li>
                            <li class="collection-item avatar">
                                <i class="material-icons circle red">local_dining</i>
                                <h5 class="titles">Recipes</h5>
                                <router-link
                                    v-bind:to="{name: 'view-recipes', params: {test_id: test.id}}"
                                    class="btn blue secondary-content"
                                >Show/Edit</router-link>
                            </li>
                            <li class="center-align">
                                <button class="btn red" id="deleteBtn" @click="deleteTest(test.id, test.title)">delete test</button>
                            </li>
                        </ul>
                    </div>
                </li>
            </ul>

            <router-link to="/add-test" class="btn green" style="margin:20px">
                Add Test
            </router-link>
        </div>
    </div>
</template>

<script>
import { testQueryMixin } from '../../mixins/testMixin/testQueryMixin'
import { testMixin } from '../../mixins/testMixin/testMixin'
    
export default {
    name: "view-tests",
    mixins: [testQueryMixin, testMixin],
    data() {
        return {
            // collection of all tests in the database
            tests: []
        }
    },
    created() {
        this.getTests()
    }
}

</script>

<style scoped>
#title {
    font-size: 17pt
}
.titles {
    font-size: 15pt;
}
#badge {
    padding: 3px;
}
#deleteBtn {
    margin-top: 10px;
}
</style>

