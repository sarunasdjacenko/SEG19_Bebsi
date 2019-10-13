import { shallowMount, RouterLinkStub } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/tests/dailycheckups/EditDailyCheckups.vue";

describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs: {
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "edit-dailycheckups",
        params: { daily_id: "code", test_id: "id" }
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
    test("has the right title", ()=> {
        expect(wrapper.find('h3').text()).toBe("Edit Daily Check-ups")
    }),
    test("has the right amount of inputs", () => {
        expect(wrapper.findAll("input")).toHaveLength(1);
    }),
    test("all inputs have required attribute", () => {
        var inputArray = wrapper.findAll("input");
        // get if there is an input without the required property
        inputArray = inputArray.filter(input => !input.attributes("required"));
        expect(inputArray).toHaveLength(0);
    }),
    test("has the correct buttons rendered", () => {
        const cancelEdit = wrapper.find("#cancelEdit");
        expect(cancelEdit).toBeDefined(); 
    }),
    test("form submits successfully", () => {
        wrapper.setMethods({ updateDailyCheckups: jest.fn() });
        wrapper.find("#submit").trigger("submit");
    
        expect(wrapper.vm.updateDailyCheckups).toHaveBeenCalled();
    }),
    test("add instructions button has been called", () => {
      // initialize the method
      wrapper.setMethods({ addInstruction: jest.fn()})

      wrapper.find("#add").trigger("click");

      expect(wrapper.vm.addInstruction).toHaveBeenCalled();

    }),
      test("test if data is set correctly", () => {
        const data = {
          description:"someDescription",
          daysBeforeTest: 2,
          instructions:[{0:{answer:false,question:"Don't drink water"}}]
        };
        // calls Vue.set recursively
        const map = {}
        map[0] = {answer: false, question: "Don't drink water" }

        wrapper.setData({
          daysBeforeTest: "2",
          instructions:[map],
        });
        // Check if data() is set properly
        expect(wrapper.vm.daysBeforeTest).toMatch("2");
        expect(wrapper.vm.instructions).toHaveLength(1);
        expect(wrapper.vm.instructions).toBeDefined();
      }),
      

  db.app.delete();
});
