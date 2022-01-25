<template>
    <div class="main">
            
        <!--OJO AQUI :class="{active: mainActive}" -->
        <section class="main__tablon" >
            <div class="main__tablon__cabecera">
                <button class="button button--secondary"   @click="newCard">Nuevo</button>
                <button class="button button--secondary">Vista</button>
            </div>


            <div class="main__tablon__feed">
                <div class="main__tablon__feed__titulos">
                    <p>Numero</p>
                    <p>Descripcion</p>
                    <p>Fecha</p>
                    <p>Edit</p>
                </div>


                <div class="main__tablon__feed__carrousel">
                    <div class="element"
                        v-for="survey of surveys" :key="survey.ID_Survey"
                        @click="goToEditor(survey.ID_Survey)"
                    >
                        <p>{{ survey.Title }}</p>
                        <p>{{ survey.Description }}</p>
                        <p>{{ survey.StartDate }}</p>
                        <ion-icon name="settings-outline"></ion-icon>
                    </div>
                </div>
            </div>


        </section>
    
    </div>
</template>

<script>

    export default {
        data() {
            return {
                navegationActive: false,
                mainActive: false,
                ID_User: 1,
                surveys: []
            }
        },
        created() {
            this.axios
                .get('survey')
                .then(res => {
                    this.surveys = res.data;
                }).catch(error => {
                    console.log(error);
                });
        },
        methods: {
            toggle (){
                this.navegationActive = !this.navegationActive;
                this.mainActive = !this.mainActive;
            },

            goToEditor(ID_Survey) {
                this.$router.push(`/editor/${ID_Survey}`);
            },

            newCard() {
                this.$router.push(`/create`);
            }
        }
    }
</script>

<style>
    /* primary: colors.red.darken1, // #E53935
    secondary: colors.red.lighten4, // #FFCDD2
    accent: colors.indigo.base, // #3F51B5 */

    /* object-fit: cover; */
    
    /* --------------- MAIN --------------- */
    .main{
        /* display: flex; */
    }
    
    /* ---- Tablon ---- */
    .main__tablon{
        display: flex;
        align-items: center;
        flex-direction: column;
        justify-content: flex-start;
        /*  */
        width: 100%;
        height: 100%;
    }
    .main__tablon.active{
        display: none;
    }
    .main__tablon__cabecera{
        display: flex;
        align-items: center;
        justify-content: space-around;
        /*  */
        margin-top: 5%;
        /*  */
        width: 100%;
    }

    .main__tablon__feed{
        margin-top: 5%;
        /*  */
        width: 80%;
        /*  */
        border-radius: 5%;
    }
    .main__tablon__feed__titulos{
        display: flex;
        align-items: center;
        justify-content: space-between;
        /*  */
        margin-top: 5%;
        padding: 0 5%;
        width: 100%;
        /*  */
        color: #fff;
        text-decoration: solid underline;
    }
    .main__tablon__feed__carrousel{
        display: grid;
        width: 100%;
    }
    .main__tablon__feed__carrousel .element{
        display: flex;
        align-items: center;
        justify-content: space-between;
        /*  */
        padding: 5% 5%;
        /*  */
        color: #fff;
        transition: 0.3s;
    }
    .main__tablon__feed__carrousel .element:hover{
        border: solid 3px ;
        transform: scale(1.2);
        cursor: pointer;
    }

</style>