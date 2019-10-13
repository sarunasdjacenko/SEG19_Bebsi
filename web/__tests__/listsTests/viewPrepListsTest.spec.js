import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/tests/lists/ViewPrepLists.vue";

describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs: {
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "view-prep-lists",
        params: {  test_id: "id" }
      }
    }
  });

  test("is a Vue instance", () => {
    expect(wrapper.isVueInstance()).toBeTruthy();
  }),
  test("renders correctly", () => {
    expect(wrapper.element).toMatchSnapshot();
  }),
  test("the title is right", ()=> {
    expect(wrapper.find('h4').text()).toBe("Lists")
  }),
  test("check if table is created", () => {
    expect(wrapper.findAll('tr')).toHaveLength(1);
    expect(wrapper.findAll("th")).toHaveLength(2);
  }),
  test("test if data is set correctly", () => {
    const data = {
      id: "someID",
      title: "someTitle",
    };
    // calls Vue.set recursively
    wrapper.setData({
      lists: [{ data }]
    });
    // Check if data() is set properly
    expect(wrapper.vm.lists).toHaveLength(1);
  }),
  test("has the correct buttons rendered", () => {
    const backButton = wrapper.find("#backButton");
    const addListButton = wrapper.find('#addListButton');
    expect(backButton).toBeDefined();
    expect(addListButton).toBeDefined();
    
  }),

  db.app.delete();
});
