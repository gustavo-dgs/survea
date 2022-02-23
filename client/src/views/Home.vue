<template>
    <div class="home">

        <div class=" menu home__menu">
            <button class="button button--primary" 
                @click="newCard"
            >
                <ion-icon  class="menu__icon icon"
                    name="add-outline"
                ></ion-icon>
                <span>NEW SURVEY</span> 
            </button>
            <!-- <button class="button button--secondary">Vista</button> -->
        </div>

        <div class="home__inner">
            <div class="survey-list">

                <div class="row survey-list__header">
                    <div class="row__icon col col1">
                        <ion-icon class="icon"
                            name="document-outline"
                        ></ion-icon>
                    </div>
                    <span class="col col2"
                    >Title</span>
                    <span class="col col3"
                    >Descripcion</span>
                    <span class="col col4"
                    >Last Modification</span>
                </div>

                <template
                    v-for="survey of surveys" 
                    :key="survey.ID_Survey"
                >
                
                    <div class="row survey-list__row"
                        @click="goToEditor(survey.ID_Survey)"
                    >
                        <div class="row__icon col col1">
                            <ion-icon class="icon icon--secondary "
                                name="document-text-outline"
                            ></ion-icon>
                        </div>
                        <span class="col col2">{{ survey.Title === '' ? 'Untitle' : survey.Title }}</span>
                        <span class="col col3">{{ survey.Description }}</span>
                        <span class="col col4">{{ survey.LastModification.slice(0,10) }}</span>
                    
                    </div>

                </template>
                

            </div>

        </div>

        
    </div>
</template>

<script>

export default {
  data () {
    return {
      homeActive: false,
      surveys: []
    }
  },
  created () {
    this.axios
      .get(`survey/user/${this.$route.params.ID_User}`)
      .then(res => {
        this.surveys = res.data
      }).catch(error => {
        console.log(error)
      })
  },
  methods: {

    goToEditor (ID_Survey) {
      this.$router.push(`${this.$route.params.ID_User}/editor/${ID_Survey}`)
    },

    newCard () {
      this.$router.push(`${this.$route.params.ID_User}/create`)
    }
  }
}
</script>

<style>
    /* primary: colors.red.darken1, // #E53935
    secondary: colors.red.lighten4, // #FFCDD2
    accent: colors.indigo.base, // #3F51B5 */

    /* --------------- home --------------- */
    .home{
        display: flex;
        position: relative;
        flex-direction: column;
        align-items: center;
        width: 100%;
        height: 100%;
        overflow-y: auto;
    }

    .home__inner {
        display: flex;
        flex-direction: column;
        overflow-x: auto;
        width: 100%;
        padding: 20px;
    }

    .survey-list {
        display: flex;
        flex-direction: column;
        background: #fff;
        width: 100%;
        min-width: min-content;
        flex-grow: 1;
        border-radius: 20px;
        
    }

    .row {
        width: 100%;
        display: flex;
        flex-direction: row;
        align-items: center;
        border-top: 1px solid #b1b1b1;
        /* margin-top: 1px solid #808080; */
    }

    .survey-list__header {
        border-top: none;
    }

    .survey-list__row:hover{
        /* border: solid 3px ; */
        transform: scale(1.02);
        background: #e2e2e2;
        cursor: pointer;
        box-shadow: 0 25px 45px rgba(0,0,0,0.1);
    }

    .col {
        flex-basis: 5%;
        height: 100%;
        display: flex;
        align-items: center;
        padding: 10px;
        min-width: 50px;
    }

    .col2 {
        flex-grow: 1;
        flex-basis: 30%;
    }

    .col3{
        flex-grow: 1;
        flex-basis: 45%;
    }

    .col4 {
        flex-grow: 1;
        flex-basis: 20%;
        min-width: 120px;
    }


</style>
