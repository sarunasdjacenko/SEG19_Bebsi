import { shallowMount } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
// @ts-ignore
import Component from "../../src/components/auth/ResetPassword.vue";
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
      const goBackBtn = wrapper.find("#backToLoginBtn");
      const resetPasswordBtn = wrapper.find("#resetPassBtn");

      expect(resetPasswordBtn).toBeDefined();
      expect(goBackBtn).toBeDefined();
    }),
    test("resets password successfully", () => {
      wrapper.setMethods({ sendResetEmail: jest.fn() });
      wrapper.find("#resetPassBtn").trigger("click");

      expect(wrapper.vm.sendResetEmail).toHaveBeenCalled();
    });
});