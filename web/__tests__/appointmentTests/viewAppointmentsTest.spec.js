import { shallowMount } from "@vue/test-utils";
import Vue from "vue";
import VueRouter from "vue-router";
import db from "../../src/components/firebaseInit";
import firebase from "firebase/app";
// @ts-ignore
import Component from "../../src/components/appointments/Appointments.vue";
Vue.use(VueRouter);

describe("Component", () => {
  const wrapper = shallowMount(Component);
  const data1 = {
    code: "someId",
    staffMember: "someStaff",
    location: "someLocation",
    id: "someId",
    testID: "someTest",
    expired: false
  };
  const data2 = {
    code: "someId2",
    staffMember: "someStaff2",
    location: "someLocation2",
    id: "someId2",
    testID: "someTest2",
    expired: false
  };
  wrapper.setData({
    allAppointments: [{ data1 }, { data2 }],
    appointments: [],
    dailyCheckups: [],
    notifications: [1, 2],
    ids: ["id1", "id2"],
    staffMemberID: "",
    today: new Date(),
    yesterday: null,
    currentDate: Date.now().toLocaleString,
    pastString: ""
  });
  wrapper.setProps({ past: true });
  test("is a Vue instance", () => {
    expect(wrapper.isVueInstance()).toBeTruthy();
  }),
    //snapshot test
    test("renders correctly", () => {
      expect(wrapper.element).toMatchSnapshot();
    }),
    test("has the correct buttons rendered", () => {
      const selectDropDown = wrapper.find("#select");
      const calendarIconBtneditBtn = wrapper.find("#datePicker");
      const searchBtn = wrapper.find("#searchBtn");
      const resetBtn = wrapper.find("#resetBtn");
      const viewAppBtn = wrapper.find("#viewAppBtn");
      const deleteAppBtn = wrapper.find("#deleteAppBtn");
      const msgBtn = wrapper.find("#msgBtn");
      const addAppBtn = wrapper.find("#addAppBtn");
      const expireAppBtn = wrapper.find("#expireAppBtn");

      expect(selectDropDown).toBeDefined();
      expect(calendarIconBtneditBtn).toBeDefined();
      expect(searchBtn).toBeDefined();
      expect(resetBtn).toBeDefined();
      expect(viewAppBtn).toBeDefined();
      expect(deleteAppBtn).toBeDefined();
      expect(msgBtn).toBeDefined();
      expect(addAppBtn).toBeDefined();
      expect(expireAppBtn).toBeDefined();
    }),
    test("check if delete method is triggered", () => {
      wrapper.setMethods({ deleteAppointment: jest.fn() });
      wrapper.vm.deleteAppointment("someCode");
      expect(wrapper.vm.deleteAppointment).toHaveBeenCalled();
    }),
    test("check if expire method is triggered", () => {
      wrapper.setMethods({ expireAppointment: jest.fn() });
      wrapper.vm.expireAppointment("someCode", false);
      expect(wrapper.vm.expireAppointment).toHaveBeenCalled();
    }),
    test("check if clearData() method works as advertised", () => {
      expect(wrapper.vm.ids).toHaveLength(2);
      expect(wrapper.vm.notifications).toHaveLength(2);
      wrapper.vm.clearData();
      expect(wrapper.vm.appointments).toHaveLength(0);
      expect(wrapper.vm.ids).toHaveLength(0);
      expect(wrapper.vm.notifications).toHaveLength(0);
    });
  db.app.delete();
});
