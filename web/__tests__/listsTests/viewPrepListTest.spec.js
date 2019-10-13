import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/tests/lists/ViewPrepList.vue";

describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs: {
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "view-prep-list",
        params: { test_id: "id",contents:"list" }
      }
    }
  });

  test("is a Vue instance", () => {
    expect(wrapper.isVueInstance()).toBeTruthy();
  }),
  test("renders correctly", () => {
    expect(wrapper.element).toMatchSnapshot();
  }),
  test("check if table is populated correctly", () => {
    // <ul></ul> exists
    expect(wrapper.find("ul").exists()).toBe(true);
  }),
  test("test if data is set correctly", () => {

    // calls Vue.set recursively
    wrapper.setData({
      title: "someTitle"
    });
    // Check if data() is set properly    expect(wrapper.vm.daysBeforeTest).toMatch("4");
    expect(wrapper.vm.title).toMatch("someTitle");
  }),
  test("has the correct buttons rendered", () => {
    const backButton = wrapper.find("#backButton");
    const editButton = wrapper.find("#editButton");
    const deleteButton = wrapper.find("#deleteButton");
    expect(backButton).toBeDefined();
    expect(editButton).toBeDefined();
    expect(deleteButton).toBeDefined();
  }),
  test("check if delete method is triggered", () => {
    wrapper.setMethods({ deleteList: jest.fn() });
    wrapper.find("#deleteButton").trigger("click");
    expect(wrapper.vm.deleteList).toHaveBeenCalled();
  }),

  db.app.delete();
});
