<template>
    <div class="user">
      <div class="dark-background"
        :class="{'opacity-value': is_aside_open}"
        @click="toggle"
      ></div>
      <survea-header class="user__survea-header"
        @show-aside="toggle"
      >
      </survea-header>
      <suvea-aside class="user__survea-aside"
        :class="{open: is_aside_open}"
      ></suvea-aside>
      
      <router-view class="user__router-view"/>
    
    </div>

</template>

<script>
import AsideVue from '../components/Aside.vue'
import HeaderVue from '../components/Header.vue'


export default {
  data() {
    return {
      is_aside_open: false
    }
  },
  components: {
    'survea-header': HeaderVue,
    'suvea-aside': AsideVue
  },
  methods: {
    toggle() {
      this.is_aside_open = !this.is_aside_open;
    }
  }
}
</script>

<style>

  .user {
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100%;
  }

  .user__survea-header {
    z-index: 50;
    position: fixed;
    width: 100%;
  }

  .dark-background {
    position: fixed;
    visibility: hidden;
    background: rgba(0, 0, 0, 0);
    height: 100%;
    width: 100%;
    z-index: 100;
    transition: background-color .6s, visibility .65s;
  }

  .opacity-value {
    background: rgba(0,0,0,.6);
    visibility: visible;
  }

  .user__survea-aside {
    position: fixed;
    height: 100%;
    z-index: 150;
    transform: translate(-100%);
    transition: transform .5s;
  }

  .user__survea-aside.open {
    transform: translate(0);
    transition: transform .5s;
  }

  .user__router-view {
    padding-top: var(--header-height);
  }

  @media only screen and (min-width: 992px) {

     .dark-background {
       visibility: hidden;
       background: rgba(0, 0, 0, 0);
       transition: background-color .6s, visibility .65s;
     }

    .user__survea-aside {
      transform: translate(0);
      padding-top: var(--header-height);
    }

    .user__router-view {
      padding-left: var(--aside-width);
    }
  }

</style>
