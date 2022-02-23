<template>
    <div class="survea-aside">
        <aside class="main__profile-menu">
            <img class="main__profile-menu--imagen" src="../assets/profile/profile_02.jpg" alt="profile_02.jpg">
            <div class="main__profile-Menu__carrousel">
                <ul>
                    <li>Example</li>
                    <li>Example</li>
                    <li>Example</li>
                    <!-- <li>Example</li>
                    <li>Example</li>
                    <li>Example</li> -->
                </ul>
            </div>
            <footer class="aside__footer">(C)2022 - UCAB Extension Guayana</footer>
        </aside>
    </div>
</template>

<script>
export default {

}
</script>

<style>
    /* ---- menu ---- */

    :root {
        --aside-width: 250px;
    }

    .survea-aside {
        width: var(--aside-width);
    }

    .main__profile-menu{

        /* cambios de GUS */
        background: #fff;
        /*  */
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        align-items: center;
        /*  */
        width: 100%;
        height: 100%;
        padding: 10px;
        /* height: 100vh; */
        /* display: none; */
        /*  */
        transition: width 0.3s;
        color: #000

    }
    /* .main__profile-menu.active{
        width: 100%;
    } */
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
        /* color: #fff; */
        list-style: none;
    }
    .main__profile-Menu__carrousel ul li:hover{
        text-decoration: underline 3px;
    }
    .main__profile-Menu__carrousel p{
        color: #ffffff25;
    }

    .aside__footer {
        justify-self: flex-end;
    }

    
</style>