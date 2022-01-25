<template>

  <div class="editor">

    <div class="question-list">

        <h1 class="editor__title">
            Encuesta
        </h1>

        <span> {{ questionsTitles }} </span>

        <div class="question-list__inner"
            v-for="q in questionArr"
            :key="q.id"
        >
            <dropzone class="editor__dropzone"
                v-show="isDropzoneVisible"
                :index="questionArr.indexOf(q)"
                @order-question-card="orderQuestionCard($event)"
            ></dropzone>

            <QuestionCard class="question-list__question-card"
                :question="q"
                @delete-question-card="deleteQuestionCard($event)"
                @show-dropzones="isDropzoneVisible=true"
                @hide-dropzones="isDropzoneVisible=false"
                @dragged-card="draggedCard=$event"
            />

        </div>

        <dropzone class="editor__dropzone"
            v-show="isDropzoneVisible"
            :index="-1"
            @order-question-card="orderQuestionCard($event)"
        ></dropzone>

        <button
            class="editor__button"
            @click="createNewQuestionCard"
        >+
        </button>

    </div>



  </div>

</template>

<script>
import QuestionCard from '../components/Question-card.vue';
import Dropzone from '../components/Dropzone.vue';

class Question {
    // constructor(id, type = 'select', title = 'Question title', description = 'Question description',
    //             options = ['option 1', 'option 2', 'option 3']) {
    //     this.id = id;
    //     this.type = type;
    //     this.title = title;
    //     this.description = description;
    //     this.options = options;
    // }

    constructor(id, order) {
        this.id = id;
        this.type = 'select';
        this.title ='';
        this.description = '';
        this.options = [];
        this.order = order;
    }
}

export default {
    data() {
        return {
            qustionsId: 0,
            questionArr: [],
            isDropzoneVisible: false,
            draggedCard: null
        }
    },
    components: {
        QuestionCard,
        'dropzone': Dropzone
    },
    methods: {
        createNewQuestionCard() {
            this.questionArr.push(new Question(this.qustionsId++, this.questionArr.length));
        },
        deleteQuestionCard(question) {
            this.questionArr.splice( this.questionArr.indexOf(question) , 1);
        },
        orderQuestionCard(newIndex) {
            if (this.draggedCard !== null){


                let oldIndex = this.questionArr.indexOf(this.draggedCard);

                if (newIndex === -1) {
                    newIndex = this.questionArr.length;
                }
                if (newIndex < oldIndex) {
                    oldIndex++;
                }

                this.questionArr.splice(newIndex, 0, this.draggedCard);
                this.questionArr.splice(oldIndex, 1);

                this.draggedCard = null;
            }
        }
    },
    computed: {
        questionsTitles() {
            const arr = [];
            for (let q of this.questionArr) {
                arr.push(q.title);
            }

            return arr;
        }
    }
};
</script>

<style>

    .editor {
        display: flex;
        flex-direction: row;
        justify-content: center;
        padding: 20px;
        width: 100%;
        margin: auto;
    }

    .editor__title {
        color: white;
    }

    span {
        width: 100%;
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

    .question-list__inner {
        width: 100%;
        display: flex;
        flex-direction: column;
    }

    .question-list__question-card {
        margin: 10px 0px;
    }

    .editor__button {
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
        margin-top: 15px;
    }

    .editor__button:active {
        background: #75a77b;
    }

</style>