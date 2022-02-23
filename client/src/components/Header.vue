<template>
  
    <header class="header">
        <div class="header__primario">
            <ion-icon class=" icon header__primario--menu-icon" 
                name="menu-outline"
                @click="this.$emit('show-aside');" 
            ></ion-icon>
            <div class="header__primario__logo">
                <div class="img-container">
                    <img class="header__img" src="../assets/apple-touch-icon.png" alt="survea_logo.png">
                </div>
                <span>SURVEA</span>
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

</template>

<script>
export default {

  emits: ['show-aside']
  
}
</script>

<style>

    /* ---- header ----- */

    :root {
        --header-height: 60px;
    }

    .header{
        display: flex;
        align-items: center;
        justify-content: space-between;
        /*  */
        height: var(--header-height);
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

    .img-container {
        width: 40px;
        height: 40px;
        margin-right: 20px;
    }

    .header__img {
        height: 100%;
        width: 100%;
        border-radius: 10px;
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

    @media only screen and (min-width: 992px) {

        .header__primario--menu-icon {
            display: none;
        }
    }
    
</style>
