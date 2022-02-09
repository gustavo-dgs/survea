<template>
    <div class="tab-allquestions">

        <select class="tab-allquestions__select"
            v-model="currentSurveyed"
        >
            <option class="tab-allquestions__option"
                v-for="(sur, i) of surveyed"
                :key="i"
                :value="i"
            >
                {{ i }}
            </option>
        </select>

        <div class="tab-allquestions__answer-card card"
            v-for="question of surveyed[currentSurveyed].questions"
            :key="question.ID_Question"
        >

            <resizable-textarea
                class="chart-card__resizable-textarea resizable-textarea--title"
                v-model="question.Question"
                disabled
            ></resizable-textarea>
            
            <hr/>

            <resizable-textarea
                class="chart-card__resizable-textarea resizable-textarea--description"
                v-model="question.Answer"
                placeholder="Not answered"
                disabled
            ></resizable-textarea>
        
        </div>
    </div>
</template>

<script>

export default {
   
    data() {
        return {
            currentSurveyed: 0,
            surveyed: [
                {questions: []}
            ],
        }
    },
    created() {
        
        this.axios.get(`results/answers/${this.$route.params.ID_Survey}`)
        .then( res => {

            this.surveyed = this.$splitResulSet(res.data, [
                {
                    thisId: 'ID_Surveyed',
                    son: 'questions',
                    columns: [
                        'ID_Surveyed'
                    ]
                },
                {
                    thisId: 'ID_Question',
                    linkId: 'ID_Surveyed',
                    columns: [
                        'ID_Question',
                        'Question',
                        'Answer',
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
    .tab-allquestions {
        display: flex;
        flex-direction: column;
    }

    .tab-allquestions > * {
        margin: 10px 0;
    }

    .tab-allquestions__select {
        width: 200px;
        align-self: center;
        height: 30px;
        border-radius: 10px;
        font-size: 15px;
        padding-left: 10px;
    }
</style>