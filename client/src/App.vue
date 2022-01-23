<template>
  <div class="main-container">
    <Header/>
    <router-view class="main-container__router-view"/>
  </div>
  
</template>

<script>
import Header from './components/Header.vue'

export default {
  components: {
    Header
  }
}
</script>


<style>
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }
  
  /* #app {
  } */

   @import url('https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,600;1,100&display=swap');
    *{
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Poppins', sans-serif;
    }
    body{
        background: #2c2525;
        overflow-x: hidden;
    }
    body::-webkit-scrollbar{
        width: 8px;
        margin-right: 5px;
    }
    body::-webkit-scrollbar-thumb{
        background: #edeaf1;
        border-radius: 4px;
        border-right: 5px solid #2c2525;
        /* margin-right: 10px; */
    }
    body::-webkit-scrollbar-thumb:active {
        background-color: #d6d3da;
    }

</style>
