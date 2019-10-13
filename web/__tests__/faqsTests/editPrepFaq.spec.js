import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/tests/faqs/EditPrepFaq.vue";

describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs: {
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "edit-prep-faq",
        params: { test_id: "id", faq_id: "faq" }
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
      expect(wrapper.findAll("input")).toHaveLength(4);
    }),
    test("the title is right", ()=> {
        expect(wrapper.find('h3').text()).toBe("Edit FAQ")
    }),
    test("has the correct buttons rendered", () => {
        const cancelButton = wrapper.find("#cancelButton");
        const submitButton = wrapper.find("#submitButton");
        expect(cancelButton).toBeDefined(); 
        expect(submitButton).toBeDefined();  
    })
    test("form submits successfully", () => {
        wrapper.setMethods({ updateFAQ: jest.fn() });
        wrapper.find("#submitButton").trigger("submit");
    
        expect(wrapper.vm.updateFAQ).toHaveBeenCalled();
    })
    

  db.app.delete();
});
