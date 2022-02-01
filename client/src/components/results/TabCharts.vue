<template>
    <div class="tab-charts">

        <chart-card class="tab-charts__chart-card"
            v-for="question of questions"
            :key="question.ID_Question"
            :question="question"
        ></chart-card>

    </div>
</template>

<script>
import ChartCardVue from './ChartCard.vue'
import { provide, reactive,  toRefs } from 'vue'

export default {
    setup() {
        const questionsReact = reactive({
            questions: []
        });

        let {questions} = toRefs(questionsReact);

        provide('questions', questions);

        return {
            questions
        }

    },
    components: {
        'chart-card': ChartCardVue
    },
    created() {
        
        this.axios.get(`results/${this.$route.params.ID_Survey}`)
        .then( res => {

            this.questions = this.$splitResulSet(res.data, [
                {
                    thisId: 'ID_Question',
                    son: 'answers',
                    columns: [
                        'ID_Question',
                        'Question',
                    ]
                },
                {
                    thisId: 'Answer',
                    linkId: 'ID_Question',
                    columns: [
                        'Answer',
                        'Total'
                    ]
                }
            ]);

        }).catch(err => {
            console.log(err);
        });
        
    }
}
</script>

<style>
    .tab-charts {
        display: flex;
        flex-direction: column;
    }

    .tab-charts > * {
        margin: 10px 0;
    }

</style>