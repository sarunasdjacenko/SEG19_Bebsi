<template>
  <div id="view-articles">
    <div id="mainScreen">
      <ul class="collection with-header">
        <li class="collection-header">
          <h4 style="font-size:3em;">
            <b>Articles</b>
          </h4>
          <h5>
            <b>Test:</b>
            {{test_title}}
          </h5>

          <div v-if="articles.length === 0" class="row">
            <div class="col s12">
              <div class="card-panel light-blue">
                <span class="card-title white-text">
                  <i class="small material-icons">info_outline</i>Info
                </span>
                <p class="white-text">
                  There are currently no articles for this test.
                  <br>To add one, please click on the button below.
                </p>
              </div>
            </div>
          </div>

          <table v-else class="collection with-header">
            <thead class="collection-header">
              <tr style="font-size:1.5em">
                <th style="padding: 20px;">Article title</th>
                <th class="right" style="margin-right: 20px;">Description</th>
                <th></th>
              </tr>
            </thead>

            <tbody v-for="article in articles" v-bind:key="article.id" class="collection-item">
              <tr>
                <td style="padding: 20px;">{{article.title}}</td>
                <td class="right">
                  <router-link
                    v-bind:to="{name: 'edit-article', params: {test_id: test_id, article_id: article.id, test_title: test_title}}"
                    class="btn blue"
                  >Show/edit</router-link>
                </td>
                <td>
                  <a class="tooltip">
                    <span class="tooltiptext">Delete Article</span>
                    <i
                      @click="deleteArticle(article.id)"
                      class="red-text material-icons"
                      style="position:relative;text-align:center;cursor:pointer;"
                    >delete</i>
                  </a>
                </td>
              </tr>
            </tbody>
          </table>
          <router-link
            v-bind:to="{name: 'add-article', params: {test_id: this.test_id, test_title: this.test_title}}"
            class="btn green"
          >Add article</router-link>
          <router-link to="/view-tests" class="btn grey">back</router-link>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { articleQueryMixin } from "../../../mixins/articleMixin/articleQueryMixin";
import { articleMixin } from "../../../mixins/articleMixin/articleMixin";

export default {
  name: "view-articles",
  mixins: [articleQueryMixin, articleMixin],
  data() {
    return {
      articles: []
    };
  },
  created() {
    this.getArticles();
  },
  methods: {
    // re route to the edit article page
    editArticle() {
      this.$router.push({
        name: "edit-article",
        params: {
          test_id: this.test_id,
          article_id: article.id,
          test_title: this.test_title
        }
      });
    }
  }
};
</script>
