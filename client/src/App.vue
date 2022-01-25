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

    /* ICONS */

    .icon {
      font-size: 22px;
      cursor: pointer;
    }

    .icon--create {
        color: #44974f;
    }

    .icon--delete {
        color: #bb2924;
        
    }

    .icon--secundary {
        color: #0d8bd4;
    }

    /* BUTTON */

    .button {
        padding: 5px;
        border-radius: 10px;
        height: 35px;
        display: flex;
        flex-direction: row;
        justify-content: center;
        align-items: center;
        border: none;
    }

    .button--primary {
        background: #44974f;
    }

    .button--primary:active {
        background: #75a77b;
    }

    .button--secondary{
        border: solid #fff;
        background: transparent;
        color: #fff;
    }

    .button--secondary:hover{
        text-decoration: underline 3px;
        background: #fff;
        color: #44974f;
    }

</style>
