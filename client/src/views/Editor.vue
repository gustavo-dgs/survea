<template>

  <div class="editor-container">

    <h1 class="editor-container__title">Encuesta {{ $route.params.id }}</h1>

    <div class="question_list">

        <question-card v-for="type of questionArr" :key="type" :questionType="type"/>

    </div>

  </div>

</template>

<script>
import QuestionCard from '../components/Question-card.vue';

export default {
    data() {
        return {
            questionType: 'checkbox',
            questionArr: ['checkbox', 'radio', 'text', 'date', 'textarea']
        }
    },
    components: {
        'question-card': QuestionCard
    }
};
</script>
        QuestionCard

<style>
    .editor-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 20px;
    }

    .editor-container__title {
        color: white;
    }

    .question-list {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-content: flex-start;
        max-width: 500px;
    }
    
</style>