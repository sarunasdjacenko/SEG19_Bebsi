import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/appointments/AddAppointment.vue";

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
      expect(wrapper.findAll("input")).toHaveLength(6);
    }),
    test("all inputs have required attribute", () => {
      var inputArray = wrapper.findAll("input");
      // get if there is an input without the required property
      inputArray = inputArray.filter(input => !input.attributes("required"));
      expect(inputArray).toHaveLength(0);
    }),
    test("has the correct buttons rendered", () => {
      const submitAddAppBtn = wrapper.find("#submitAddAppBtn");
      const cancelAddAppBtn = wrapper.find("#cancelAddAppBtn");
      const selectTest = wrapper.find("#selectTest");

      expect(submitAddAppBtn).toBeDefined();
      expect(cancelAddAppBtn).toBeDefined();
      expect(selectTest).toBeDefined();
    }),
    test("form submits successfully", () => {
      wrapper.setMethods({ saveAppointment: jest.fn() });
      wrapper.find("#submitAddAppBtn").trigger("submit");

      expect(wrapper.vm.saveAppointment).toHaveBeenCalled();
    }),
    test("generates random code", () => {
      // initialize the method
      wrapper.setMethods({generateCode: jest.fn()})
      // get the code
      wrapper.vm.generateCode()
      const code = wrapper.vm.code

      // expect to not have a different code and to be defined
      expect(wrapper.vm.code).toBeDefined()
      expect(wrapper.vm.code).toBe(code)
    });
  db.app.delete();
});
