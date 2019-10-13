import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/appointments/EditAppointment.vue";

describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs: {
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "edit-appointment",
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
    test("has the right amount of inputs", () => {
      expect(wrapper.findAll("input")).toHaveLength(5);
    }),
    test("all inputs have required attribute", () => {
      var inputArray = wrapper.findAll("input");
      // get if there is an input without the required property
      inputArray = inputArray.filter(input => !input.attributes("required"));
      expect(inputArray).toHaveLength(0);
    }),
    test("has the correct buttons rendered", () => {
      const submitEditAppBtn = wrapper.find("#submitEditAppBtn");
      const cancelAppEditBtn = wrapper.find("#cancelAppEditBtn");
      const selectRefStaff = wrapper.find("#selectRefStaff");

      expect(submitEditAppBtn).toBeDefined();
      expect(cancelAppEditBtn).toBeDefined();
      expect(selectRefStaff).toBeDefined();
    }),
    test("form submits successfully", () => {
      wrapper.setMethods({ updateAppointment: jest.fn() });
      wrapper.find("#submitEditAppBtn").trigger("submit");

      expect(wrapper.vm.updateAppointment).toHaveBeenCalled();
    }),
    test("has the right title", ()=> {
      expect(wrapper.find('h3').text()).toBe("Edit Appointment")
    });
  db.app.delete();
});
