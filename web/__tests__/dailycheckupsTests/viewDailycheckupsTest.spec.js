import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/tests/dailycheckups/ViewDailyCheckups.vue";

describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs: {
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "view-dailycheckups",
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
    expect(wrapper.find('h4').text()).toBe("Daily Check-ups")
  }),
  test("check if table is created", () => {
    expect(wrapper.findAll('tr')).toHaveLength(1);
    expect(wrapper.findAll("th")).toHaveLength(3);
  }),
  test("has the correct buttons rendered", () => {
    const GoBackTest = wrapper.find("#GoBackTest");
    expect(GoBackTest).toBeDefined();
    
  }),

  db.app.delete();
});
