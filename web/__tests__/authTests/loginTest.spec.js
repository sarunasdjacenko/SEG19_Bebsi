import { shallowMount } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
// @ts-ignore
import Component from "../../src/components/auth/Login.vue";
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
      const loginBtn = wrapper.find("#loginBtn");
      const resetPasswordBtn = wrapper.find("#resetPasswordBtn");

      expect(resetPasswordBtn).toBeDefined();
      expect(loginBtn).toBeDefined();
    }),
    test("form submits successfully", () => {
      wrapper.setMethods({ login: jest.fn() });
      wrapper.find("#loginBtn").trigger("click");

      expect(wrapper.vm.login).toHaveBeenCalled();
    }),
    test("has the right amount of inputs", () => {
        expect(wrapper.findAll("input")).toHaveLength(2);
    });
});
