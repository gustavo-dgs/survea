<template>
    <div class="chart-card card">

        <resizable-textarea
            class="chart-card__resizable-textarea resizable-textarea--title"
            placeholder="Question title"
            v-model="question.Question"
            disabled
        ></resizable-textarea>
        
        <hr/>

        <bar-chard class="chart-card__chart"
            :answers="question.answers"
        ></bar-chard>

    </div>
</template>

<script>
import QuestionCardVue from '../editor/Question-card.vue'
import BarChartVue from './BarChart.vue'


export default {
    components: {
        'question-card': QuestionCardVue,
        'bar-chard': BarChartVue
    },
    props: {
        question: Object
    }
}
</script>

<style>

    .chart-card__chart {
        align-self: center;
        height: 300px;
        width: 300px;
    }

</style>