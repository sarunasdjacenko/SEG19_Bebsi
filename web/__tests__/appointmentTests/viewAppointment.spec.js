import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/appointments/ViewAppointment.vue";

describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs: {
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "view-appointment",
        params: { expired: false, id: "id" }
      }
    }
  });

  test("is a Vue instance", () => {
    expect(wrapper.isVueInstance()).toBeTruthy();
  }),
    //snapshot test
    test("renders correctly", () => {
      expect(wrapper.element).toMatchSnapshot();
    }),
    test("check if table is populated correctly", () => {
      // generate 2 tables
      expect(wrapper.findAll('tr')).toHaveLength(2);
      // Check if all ths are rendered
      expect(wrapper.findAll("th")).toHaveLength(7);
    }),
    test("has the correct buttons rendered", () => {
      const goToEditAppBtn = wrapper.find("#goToEditAppBtn");
      const goToCurrentAppBtn = wrapper.find("#goToCurrentAppBtn");
      const goToPastAppBtn = wrapper.find("#goToPastAppBtn");

      expect(goToEditAppBtn).toBeDefined();
      expect(goToCurrentAppBtn).toBeDefined();
      expect(goToPastAppBtn).toBeDefined();
    }),
    test("has the right title", ()=> {
      // initializes the right $route param
      expect(wrapper.find('h4').text()).toBe("Appointment: " + wrapper.vm.$route.params.id)
    });
  db.app.delete();
});
