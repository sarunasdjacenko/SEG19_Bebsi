import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/tests/dailycheckups/ViewDailyCheckupsInfo.vue";

describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs: {
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "view-dailycheckups-info",
        params: { test_id: "id",daily_id:"code" }
      }
    }
  });

  test("is a Vue instance", () => {
    expect(wrapper.isVueInstance()).toBeTruthy();
  }),
  test("renders correctly", () => {
    expect(wrapper.element).toMatchSnapshot();
  }),
  test("check if lists are populated correctly", () => {
    // <ul></ul> exists
    expect(wrapper.find("ul").exists()).toBe(true);
    expect(wrapper.findAll("li")).toHaveLength(5)
  }),
  test("the title is right", ()=> {
    expect(wrapper.find('h4').text()).toBe("Daily Checkups Information:")
  }),
  test("test if data is set correctly", () => {
    const data = {
      daysBeforeTest: 4
    };
    // calls Vue.set recursively
    wrapper.setData({
      daysBeforeTest: "4"
    });
    // Check if data() is set properly
    expect(wrapper.vm.daysBeforeTest).toMatch("4");
  }),
  test("has the correct buttons rendered", () => {
    const GoEditCheckups = wrapper.find("#GoEditCheckups");
    const DeleteCheckups = wrapper.find("#DeleteCheckups");
    const GoBackDaily = wrapper.find("#GoBackDaily");
    expect(GoEditCheckups).toBeDefined();
    expect(DeleteCheckups).toBeDefined();
    expect(GoBackDaily).toBeDefined();
  }),
  test("check if delete method is triggered", () => {
    wrapper.setMethods({ deleteDailyCheckups: jest.fn() });
    wrapper.find("#DeleteCheckups").trigger("click");
    expect(wrapper.vm.deleteDailyCheckups).toHaveBeenCalled();
  }),

  db.app.delete();
});
