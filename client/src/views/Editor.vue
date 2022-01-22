<template>

  <div class="editor-container">

    <div class="question-list">
        <h1 class="editor-container__title">
            Encuesta {{ $route.params.id }}
        </h1>

        <QuestionCard
            v-for="q in questionArr"
            :key="q.id"
            :question="q"
        />

        <button
            class="editor-container__button"
            @click="createNewQuestionCard"
        >+
        </button>

    </div>

    

  </div>

</template>

<script>
import QuestionCard from '../components/Question-card.vue';

class Question {
    // constructor(id, type = 'select', title = 'Question title', description = 'Question description', 
    //             options = ['option 1', 'option 2', 'option 3']) {
    //     this.id = id;
    //     this.type = type;
    //     this.title = title;
    //     this.description = description;
    //     this.options = options;
    // }

    constructor(id) {
        this.id = id;
        this.type = 'select';
        this.title ='Question title';
        this.description = 'Question description';
        this.options = ['option 1', 'option 2', 'option 3'];
    }
}

export default {
    data() {
        return {
            qustionsId: 0,
            questionArr: []
        }
    },
    components: {
        QuestionCard
    },
    methods: {
        createNewQuestionCard() {
            this.questionArr.push(new Question(this.qustionsId++));
        }
    }
};
</script>
        QuestionCard

<style>
    .editor-container {
        display: flex;
        flex-direction: row;
        justify-content: center;
        padding: 20px;
        width: 100%;
        margin: auto;
    }

    .editor-container__title {
        color: white;
    }

    .question-list {
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        justify-content: center;
        align-content: flex-start;
        flex-grow: 1;
        min-width: 300px;
        max-width: 600px;
        outline: 1px solid red;
    }

    .editor-container__button {
        width: 100%;
        height: 35px;
        border-radius: 30px;
        border: none;
        background: #44974f;
        font-size: 30px;
        display: flex;
        flex-direction: row;
        justify-content: center;
        align-items: center;
        color: white;
    }

    .editor-container__button:active {
        background: #75a77b;
    }
    
</style>