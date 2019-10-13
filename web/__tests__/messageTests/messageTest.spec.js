import { shallowMount, RouterLinkStub} from "@vue/test-utils";
import db from "../../src/components/firebaseInit";
// @ts-ignore
import Component from "../../src/components/messages/Message.vue";


describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs:{
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "message",
        params: { expired: false, appointmentID: "appointmentID" }
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
  test("form submits successfully", () => {
    wrapper.setMethods({ sendMessage: jest.fn() });
    wrapper.find("#sendMessage").trigger("submit");

    expect(wrapper.vm.sendMessage).toHaveBeenCalled();
  }),
  test("has the correct buttons rendered", () => {
    const sendMessageBtn = wrapper.find("#sendMessage");
    const pastBtn = wrapper.find("#pastApp");
    const currentBtn = wrapper.find("#currentApp");
    const textArea = wrapper.find("#textArea");
    expect(sendMessageBtn).toBeDefined();
    expect(pastBtn).toBeDefined();
    expect(currentBtn).toBeDefined();
    expect(textArea).toBeDefined();
  });
  db.app.delete()
});
