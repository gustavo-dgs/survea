<template>

    <div class="editor">

        <header class="editor__header">

            <div class="menu">
                <ion-icon
                    class="menu__copy icon icon--secundary"
                    name="copy"
                ></ion-icon>
                
                <h4 class="editor__upadate-status">
                    {{ updateStatus }}
                </h4>

                <ion-icon class="menu__delete icon icon--delete"
                    name="trash"
                    @click="deleteSurvey()"
                ></ion-icon>

                <ion-icon class="menu__preview icon icon--secundary"
                    name="eye-outline"
                    @click="previewSurvey()"
                ></ion-icon>

            </div>

            <resizable-textarea
                class="editor__title"
                v-model="survey.Title"
                placeholder="Survey Title"
            ></resizable-textarea>

            <resizable-textarea
                class="editor__description"
                v-model="survey.Description"
                placeholder="Survey Description"
            ></resizable-textarea>

            <!-- <span> {{ this.survey.questions }} </span> -->
        </header>

       

        <div class="question-list">

            <div class="question-list__inner"
                v-for="(q, i) of this.survey.questions"
                :key="q.ID_Survey"
            >
                <dropzone class="editor__dropzone"
                    v-show="isDropzoneVisible"
                    :index="i"
                    @order-item="orderQuestionCard($event)"
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
                @order-item="orderQuestionCard($event)"
            ></dropzone>

            <button
                class="editor__button button button--primary"
                @click="createNewQuestionCard"
            >
                <ion-icon  class="editor__icon icon"
                    name="add-outline"
                ></ion-icon>
            </button>

        </div>

    </div>

</template>

<script>
import QuestionCard from '../components/editor/Question-card.vue'
import { provide, reactive,  toRefs } from 'vue'

export default {
    setup() {
        const surveyReact = reactive({
            survey: {
                ID_Survey: 0,
                Title: '',
                Description: '',
                ID_User: 1,
                StartDate: new Date,
                FinalDate: new Date,
                questions: []
            }
        });

        let {survey} = toRefs(surveyReact);

        //provide('survey', survey);

        return {
            survey
        }

    },
    provide() {
        return {
            survey: this.survey
        }
    },
    data() {
        return {
            questionsId: 0,
            isDropzoneVisible: false,
            draggedCard: null,
            updateStatus: 'All save',
            lastTimeOut: null,
            lastStatusTimeOut: null,
        }
    },
    created() {
        let watchEditor = () => {
            this.$watchSurvey('survey.Title', this);
            this.$watchSurvey('survey.Description', this);
            this.$watchAll('survey', this);
        }

        if (this.$route.name === 'Create'){

            this.axios
                .post('survey', this.survey)
                .then(res => {
                    this.survey.ID_Survey = res.data;
                    watchEditor();
                })
                .catch(err => {
                    console.log(err);
                });

        }else {

            this.axios
                .get(`survey/${this.$route.params.ID_Survey}`)
                .then( res => {
                    
                    this.survey = this.$splitResulSet(res.data, [
                        {
                            thisId: 'ID_Survey',
                            son: 'questions',
                            columns: [
                                'ID_Survey',
                                'Title',
                                'Description',
                                'StartDate',
                                'FinalDate',
                                'ID_User'
                            ]
                        },
                        {
                            thisId: 'ID_Question',
                            linkId: 'ID_Survey',
                            son: 'answers',
                            columns: [
                                'ID_Question',
                                'Question',
                                'Type',
                            ]
                        },
                        {
                            thisId: 'ID_Answer',
                            linkId: 'ID_Question',
                            columns: [
                                'ID_Answer',
                                'Answer',
                            ]
                        }
                    ])[0];

                    watchEditor();
                  
                })
                .catch(err => {
                    console.log(err);
                });

        }
    },
    components: {
        QuestionCard
    },
    methods: {

        updateData(resolve) {
            
            this.axios
                .put(`survey/${this.survey.ID_Survey}`, this.survey)
                .then(resolve)
                .catch(err => {
                    console.log(err);
                });
        },

        createNewQuestionCard() {

            let id = 1;
            if (this.survey.questions.length > 0) {
                let sortArr = Array.from(this.survey.questions);
                sortArr.sort((a,b) => b.ID_Question - a.ID_Question);
                id = sortArr[0].ID_Question + 1;
            }

            let question = {
                ID_Question: id,
                Type: 'select',
                Question: '',
                qOrder: this.survey.questions.length,
                Description: '',
                answers: []
            }

            this.survey.questions.push(question);

            this.axios
                .post('survey/question', {
                    ID_Question: id,
                    Type: question.Type,
                    Question: question.Question,
                    qOrder: this.survey.questions.length,
                    Description: question.Description,
                    ID_Survey: this.survey.ID_Survey,
                    ID_User: this.survey.ID_User
                })
                .then( res => {
                    console.log(res);
                })
                .catch(err => {
                    console.log(err);
                });

        },
        deleteQuestionCard(question) {
            this.survey.questions.splice( this.survey.questions.indexOf(question) , 1);

            this.axios
                .delete(`survey/question/${question.ID_Question}`, {
                    data: {
                        ID_Survey: this.survey.ID_Survey,
                        ID_User: this.survey.ID_User
                    }
                })
                .then( res => {
                    console.log(res);
                })
                .catch(err => {
                    console.log(err);
                });
        },
        orderQuestionCard(newIndex) {
            if (this.draggedCard !== null){


                let oldIndex = this.survey.questions.indexOf(this.draggedCard);

                if (newIndex === -1) {
                    newIndex = this.survey.questions.length;
                }
                if (newIndex < oldIndex) {
                    oldIndex++;
                }

                this.survey.questions.splice(newIndex, 0, this.draggedCard);
                this.survey.questions.splice(oldIndex, 1);

                this.draggedCard = null;

                for (let i=0; i<this.survey.questions.length; i++){
                    this.survey.questions[i].qOrder = i;
                }
            }
        },
        previewSurvey() {
            this.$router.push(`/survey/${this.$route.params.ID_Survey}`);
        },
        deleteSurvey() {
            this.axios
                .delete(`survey/${this.survey.ID_Survey}`)
                .then(res => {
                    console.log(res);
                    this.$router.push('/');
                })
                .catch(err => {
                    console.log(err);
                })
        }
    }
};
</script>

<style>

    .editor {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 100%;
        margin: auto;
    }

    .editor > * {
        width: 100%;
    }

    .editor__header {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 20px;
        width: 100%;
        padding: 10px;
        background: #fff;
    }

    .editor__header > * {
        margin: 5px 0;
    }

    .editor__title {
        font-size: 30px;
    }

    .editor__description {
        color: #3e454d;
        font-size: 18px;
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
        margin: 20px 0;
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
        margin-top: 15px;
    }

    .editor__icon {
        font-size: 30px;
    }

</style>