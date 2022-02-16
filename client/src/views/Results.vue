<template>
    <div class="results">

        <button class="button tab-button"
            v-for="(tab, i) in tabs"
            :key="tab"
            :class="{ 'tab-button--active': currentTab === tab }"
            @click="currentTab = tab"
        >
            {{ tabsTitles[i] }}
        </button>

        <button class="button tab-button"
            @click="Excel"
        >
           Excel
        </button>

        <component class="tab-body"
            :is="currentTabComponent"
        ></component>

    </div>
</template>

<script>
import TabAllQuestions from '../components/results/TabAllQuestions.vue'
import TabCharts from '../components/results/TabCharts.vue'

export default {
    data() {
        return {
            tabs: ['tab-charts', 'tab-allquestions'],
            tabsTitles:['Charts', 'All Questions'],
            currentTab: 'tab-charts'
        }
    },
    methods:{
        Excel(){
            this.axios.get(`results/excel/${this.$route.params.ID_Survey}`,{
            responseType: "blob", // important
                headers: {
                    "Content-Type": "application/json"
                }
            })
        .then(response => {
          const url = window.URL.createObjectURL(new Blob([response.data]));
          const link = document.createElement("a");
          link.href = url;
          link.setAttribute("download", "Encuesta.xlsx");
          document.body.appendChild(link);
          link.click();
        })
        .catch(() => {
          // Complete the animation of the  progress bar.
        });
        },
    },
    computed: {
        currentTabComponent() {
            return this.currentTab.toLowerCase();
        }
    },
    components: {
        'tab-charts': TabCharts,
        'tab-allquestions': TabAllQuestions
    }
  

}
</script>

<style>
    .results {
        display: grid;
        grid-template-rows: min-content, max-content;
        grid-template-columns: repeat(2, minmax(min-content, 300px));
        padding: 40px;
        grid-row-gap: 20px;
        grid-column-gap: 20px;
        justify-content: center;
    }

    .tab-button {
        height: 35px;
        font-size: 15px;
        border: 3px solid #fff;
        color: #fff;
        background: transparent;
    }

    .tab-button--active {
        color: #000;
        background: #fff;
        border: 3px solid #fff;
    }

    .tab-body {
        grid-row: 2;
        grid-column: 1 / -1
    }
</style>
