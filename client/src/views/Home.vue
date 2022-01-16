<template>
  <div id="container">

    <HorizontalNavbar id="horizontal-navbar" />

    <div class="container__2">
      <VerticalNavbar />

      <div class="containter__3">


        <nav class="nav">
          <a class="nav-link active" href="#">Active</a>
          <a class="nav-link" href="#">Link</a>
          <a class="nav-link" href="#">Link</a>
          <a class="nav-link disabled" href="#">Disabled</a>
          <button type="button" class="btn btn-secundary">Display</button>
          <button type="button" class="btn btn-primary">NEW</button>
        </nav>


        <table class="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col">Title</th>
              <th scope="col">Description</th>
              <th scope="col">Creation Date</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="i in 5" :key="i">
              
                <th scope="row"> <router-link :to="/editor/+i"> {{ i }} </router-link></th>
                <td><router-link :to="/editor/+i"> Encuesta {{ i }} </router-link></td>
                <td><router-link :to="/editor/+i"> Mi primera encuesta </router-link></td>
                <td><router-link :to="/editor/+i"> 15/01/2022 </router-link></td>
              
            </tr>
          </tbody>
        </table>


      </div>
    </div>
  </div>
</template>

<script>
import HorizontalNavbar from "../components/HorizontalNavbar.vue";
import VerticalNavbar from "../components/VerticalNavbar.vue";

export default {
  components: {
    HorizontalNavbar,
    VerticalNavbar,
  },
};
</script>

<style>
.container__2 {
  display: inline-flex;
  /*width: auto;*/
  margin-left: 0px;
}

.container__2 table {
  width: auto;
  margin: 0px;
}

.container__2 VerticalNavbar {
  margin-left: 0;
  width: 50px;
}

.container__3 nav {
  height: 200px;
}
</style>