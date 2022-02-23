<template>

    <section class="not-found log-sign">

        <div class="log-sign__color"></div>
        <div class="log-sign__color"></div>
        <div class="log-sign__color"></div>

        <div class="log-sing__box__square a" ></div>
        <div class="log-sing__box__square b" ></div>
        <div class="log-sing__box__square c" ></div>
        <div class="log-sing__box__square d" ></div>
        <div class="log-sing__box__square e" ></div>

        <div class="box-back">

            <div class="box not-found__box log-sing__box">

               
                <h2 class="box__title">404 PAGE NOT FOUND</h2>
                <h3 class="box__info">Looks like you've followed a broken link or entered a URL that doesn't exist on this site.</h3>
                <router-link class="box__button"
                    :to="'/'"
                >Back to our site</router-link>
                  

               
            </div>

        </div>

    </section>

</template>

<script>
import LoginVue from './Login.vue'

export default {
  components: {
    'login': LoginVue
  }
}
</script>

<style>
    .box {
        justify-content: space-around;
        color: #fff;
        padding: 25px;
    }

    .box__title {
        cursor: default;
        font-size: 28px;
        width: 100%;
        text-align: center;
    }

    .box__info {
        font-size: 19px;
    }

    .box__button {
        background: #fff;
        color: #666;
        cursor: pointer;
        font-weight: 600;
        border: none;
        outline: none;
        padding: 15px;
        border-radius: 35px;
        font-size: 15px;
        letter-spacing: 1px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        text-decoration: none;
    }


</style>
