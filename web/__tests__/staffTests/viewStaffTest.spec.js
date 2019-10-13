import { shallowMount } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
// @ts-ignore
import Component from "../../src/components/staff/ViewStaff.vue";
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
      const addStaffBtn = wrapper.find("#addStaffBtn");
      const editBtn = wrapper.find("#editBtn");
      const deleteBtn = wrapper.find("#deleteBtn");
      expect(addStaffBtn).toBeDefined();
      expect(editBtn).toBeDefined();
      expect(deleteBtn).toBeDefined();
    }),
    test("test if data is set correctly", () => {
      const data = {
        email: "someEmail",
        name: "someName",
        dept: "someDep",
        role: "someRole"
      };
      // calls Vue.set recursively
      wrapper.setData({
        isAdmin: "Admin",
        currentEmail: "someEmail",
        users: [{ data }]
      });
      // Check if data() is set properly
      expect(wrapper.vm.isAdmin).toMatch("Admin");
      expect(wrapper.vm.currentEmail).toBeDefined();
      expect(wrapper.vm.users).toHaveLength(1);
    }),
    test("check if table is populated correctly", () => {
      // <td></td> exists
      expect(wrapper.find("td").exists()).toBe(true);
      // Check if all tds are rendered
      expect(wrapper.findAll("td")).toHaveLength(6);
      // Check if all ths are rendered
      expect(wrapper.findAll("th")).toHaveLength(5);
    }),
    test("check if delete method is triggered", () => {
      wrapper.setMethods({ deleteUser: jest.fn() });
      wrapper.find("#deleteBtn").trigger("click");
      expect(wrapper.vm.deleteUser).toHaveBeenCalled();
    });
  db.app.delete();
});
