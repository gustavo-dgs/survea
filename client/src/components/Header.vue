<template>
    <div class="header-container">
        <header class="header">
            <div class="header__primario">
                <ion-icon @click="toggle" class="header__primario--menu-icon" name="menu-outline"></ion-icon>
                <div class="header__primario__logo">
                    <ion-icon name="newspaper-outline"></ion-icon>
                    <p>Survea</p>
                </div>
            </div>
            <div class="header__secundario">
                <ion-icon name="search-outline"></ion-icon>

                <router-link :to="`/user/${$route.params.ID_User}`"
                    class="button button--secondary header__button"
                >
                    Mis encuestas
                </router-link>

            </div>
        </header>

        <section class="main__profile-menu" :class="{active: navegationActive}">
            <img class="main__profile-menu--imagen" src="../assets/profile/profile_02.jpg" alt="profile_02.jpg">
            <div class="main__profile-Menu__carrousel">
                <ul>
                    <li>Example</li>
                    <li>Example</li>
                    <li>Example</li>
                    <li>Example</li>
                    <li>Example</li>
                    <li>Example</li>
                    <li>Example</li>
                    <li>Example</li>
                    <li>Example</li>
                    <li>Example</li>
                </ul>
                <p>(C)2022 - UCAB Extension Guayana</p>
            </div>
        </section>

    </div>

</template>

<script>
export default {

  data () {
    return {
      navegationActive: false
    }
  },

  methods: {
    toggle () {
      this.navegationActive = !this.navegationActive
      // this.mainActive = !this.mainActive;s
    }
  }
}
</script>

<style>

    /* ---- header ----- */
    .header{
        display: flex;
        align-items: center;
        justify-content: space-between;
        /*  */
        height: 60px;
        width: 100%;
        background: #44974f;
    }
    .header__primario{
        display: flex;
        align-items: center;
        margin-left: 10px;
    }
    .header__primario--menu-icon{
        margin-right: 15px;
        /*  */
        font-size: 40px;
        /*  */
        color: #ffffff;
    }
    .header__primario__logo{
        display: flex;
        align-items: center;
        /*  */
        color: #ffffff;
    }
    .header__primario__logo ion-icon{
        font-size: 30px;
    }
    .header__primario__logo p{
        display: none;
    }
    .header__secundario{
        display: flex;
        align-items: center;
        /*  */
        margin-right: 10px;
    }
    .header__secundario ion-icon{
        margin-right: 10px;
        /*  */
        font-size: 30px;
        color: #fff;
    }
    .header__secundario--button{
        padding: 5px;
        border-radius: 10px;
        /*  */
        border: solid #fff;
        background: transparent;
        color: #fff;
    }
    .header__secundario--button:hover{
        text-decoration: underline 3px;
        background: #fff;
        color: #44974f;
    }

    .header__button {
        font-size: 15px;
    }

    /* ---- menu ---- */
    .main__profile-menu{

        /* cambios de GUS */
        position: absolute;
        background: #2c2525;
        z-index: 10;

        /*  */
        display: flex;
        flex-direction: column;
        justify-content: flex-start;
        align-items: center;
        /*  */
        margin-top: 35px;
        width: 0;
        /*  */
        transition: 0.3s;
        overflow-x: hidden;

    }
    .main__profile-menu.active{
        width: 100%;
    }
    .main__profile-menu--imagen{
        width: 200px;
        height: 200px;
        border-radius: 100%;
        /*  */
        object-fit: cover;
        border: solid;
    }
    .main__profile-Menu__carrousel{
        display: flex;
        align-items: center;
        flex-direction: column;
        justify-content: flex-start;
        /*  */
        margin-top: 25px;
    }
    .main__profile-Menu__carrousel ul{
        margin-bottom: 25px;
    }
    .main__profile-Menu__carrousel ul li{
        margin-bottom: 15px;
        /*  */
        color: #fff;
        list-style: none;
    }
    .main__profile-Menu__carrousel ul li:hover{
        text-decoration: underline 3px;
    }
    .main__profile-Menu__carrousel p{
        color: #ffffff25;
    }

    @media only screen and (min-width: 992px) {


        
    }
</style>
