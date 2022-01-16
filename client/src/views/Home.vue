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
          <button type="button" class="btn btn-primary">Sort</button>
          <button type="button" class="btn btn-primary">Display</button>
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
              <router-link :to="/editor/+i">
                <th scope="row"> {{ i }} </th>
                <td>Encuesta {{ i }} </td>
                <td>Mi primera encuesta</td>
                <td>15/01/2022</td>
              </router-link>
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