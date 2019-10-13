<template>
  <div id="app">
    <Navbar/>
    <div id="main" class="row">
      <div>
        <Sidebar/>
      </div>
      <div id="central" class="col s12 m12 l10">
        <router-view/>
      </div>
    </div>
  </div>
</template>

<script>
import Navbar from "./components/navigation/Navbar";
import Sidebar from "./components/navigation/Sidebar";

export default {
  name: "App",
  components: {
    Navbar,
    Sidebar
  }
};
</script>

<style>
#central {
  max-height: 90vh;
  padding-bottom: 30px;
  padding-top: 30px;
  padding-right: 30px;
  min-width: 80vmax;
}
/* for components that are not in a table or list layout */
.mainContainer {
  background-color:white; 
  padding: 10px 50px 10px 50px; 
  margin-top:10px; 
  margin-bottom:30px;
  width: 100%;
  height: 100%;
}
h4 {
  padding:10px;
  font-size:3em;
  font-weight: bold;
}
.tooltip {
  position: relative;
  display: inline-block;
}
.tooltip .tooltiptext {
  visibility: hidden;
  width: 120px;
  background-color: #555;
  color: #fff;
  text-align: center;
  border-radius: 6px;
  padding: 5px 0;
  position: absolute;
  z-index: 1;
  bottom: 125%;
  left: 100%;
  margin-left: -70px;
  opacity: 0;
  transition: opacity 0.3s;
}
.tooltip .tooltiptext::after {
  content: "";
  position: absolute;
  top: 100%;
  left: 50%;
  margin-left: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: #555 transparent transparent transparent;
}
.tooltip:hover .tooltiptext {
  visibility: visible;
  opacity: 1;
}
</style>
