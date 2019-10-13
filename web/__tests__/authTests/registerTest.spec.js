import { shallowMount } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
// @ts-ignore
import Component from "../../src/components/auth/Register.vue";
Vue.use(VueRouter);

describe("Component", () => {
    const wrapper = shallowMount(Component);
    test("is a Vue instance", () => {
      expect(wrapper.isVueInstance()).toBeTruthy();
    }),
      //snapshot test
      test("renders correctly", () => {
        expect(wrapper.element).toMatchSnapshot();
      }),
      test("has the correct buttons rendered", () => {
        const registerBtn = wrapper.find("#registerBtn");
        const checkBox = wrapper.find("#check");
  
        expect(registerBtn).toBeDefined();
        expect(checkBox).toBeDefined();
      }),
      test("form submits successfully", () => {
        wrapper.setMethods({ register: jest.fn() });
        wrapper.find("#registerBtn").trigger("submit");
  
        expect(wrapper.vm.register).toHaveBeenCalled();
      }),
      test("has the right amount of inputs", () => {
          expect(wrapper.findAll("input")).toHaveLength(5);
      }),
      test("all inputs have required attribute", () => {
        var inputArray = wrapper.findAll("input");
        // get if there is an input without the required property
        inputArray = inputArray.filter(input => !input.attributes("required"));
        expect(inputArray).toHaveLength(1);
      });
  });