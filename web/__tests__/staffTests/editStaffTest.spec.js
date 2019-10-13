import { shallowMount, RouterLinkStub} from "@vue/test-utils";
import db from "../../src/components/firebaseInit";
// @ts-ignore
import Component from "../../src/components/staff/EditStaff.vue";


describe("Component", () => {
  const wrapper = shallowMount(Component, {
    stubs:{
      RouterLink: RouterLinkStub
    },
    mocks: {
      $route: {
        name: "edit-staff",
        params: { email: "email@example.com" }
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
  test("inputs have the right value", () => {
    wrapper.setData({
      email: "email",
      name: "name",
      dept: "dept",
      role: "role"
    });
    // The data() sets up properly
    expect(wrapper.vm.email).toMatch("email");
    expect(wrapper.vm.name).toMatch("name");
    expect(wrapper.vm.dept).toMatch("dept");
    expect(wrapper.vm.role).toMatch("role");
  }),
  test("form submits successfully", () => {
    wrapper.setMethods({ updateUser: jest.fn() });
    wrapper.find("#submit").trigger("submit");

    expect(wrapper.vm.updateUser).toHaveBeenCalled();
  }),
  test("all inputs have required attribute", () => {
    var inputArray = wrapper.findAll("input");
    // get if there is an input without the required property
    inputArray = inputArray.filter(input => !input.attributes("required"));
    expect(inputArray).toHaveLength(0);
  });
  db.app.delete()
});
