import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/tests/lists/EditPrepList.vue";

describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs: {
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "edit-prep-list",
        params: { test_id: "id", contents: "list" }
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
    test("the title is right", ()=> {
        expect(wrapper.find('h3').text()).toBe("Edit Preparation List")
    }),
    test("has the correct buttons rendered", () => {
        const cancelButton = wrapper.find("#cancelButton");
        const newListButton = wrapper.find("#newListButton");
        const submitButton = wrapper.find("#submitButton");
        expect(cancelButton).toBeDefined(); 
        expect(newListButton).toBeDefined();
        expect(submitButton).toBeDefined();  
    }),
    test("form submits successfully", () => {
        wrapper.setMethods({ updatePrepList: jest.fn() });
        wrapper.find("#submitButton").trigger("submit");
    
        expect(wrapper.vm.updatePrepList).toHaveBeenCalled();
    }),
    test("adds new list", () => {
        wrapper.setMethods({ addMap: jest.fn() });
        wrapper.find("#newListButton").trigger("click");
    
        expect(wrapper.vm.addMap).toHaveBeenCalled();
    })
    

  db.app.delete();
});
