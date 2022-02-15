<template>

    <div class="editor">
        
        <div class="menu editor__menu">

            <ion-icon class="menu__chart icon icon--create"
                name="bar-chart"
                @click="goToResults"
            ></ion-icon>
            
            <ion-icon class="menu__preview icon icon--secundary"
                name="eye"
                @click="previewSurvey"
            ></ion-icon>
            
            <h4 class="menu__upadate-status">
                {{ updateStatus }}
            </h4>

            <ion-icon
                class="menu__copy icon icon--secundary"
                name="copy"
            ></ion-icon>

            <ion-icon class="menu__delete icon icon--delete"
                name="trash"
                @click="deleteSurvey()"
            ></ion-icon>
            
        </div>

        <header class="editor__header">

            <resizable-textarea
                class="editor__title"
                v-model="surveyReact.survey.Title"
                placeholder="Survey Title"
            ></resizable-textarea>

            <resizable-textarea
                class="editor__description"
                v-model="surveyReact.survey.Description"
                placeholder="Survey Description"
            ></resizable-textarea>

        </header>

       

        <div class="question-list">

            <template class="question-list__inner"
                v-for="(q, i) of this.surveyReact.survey.questions"
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

            </template>

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
import { provide, reactive } from 'vue'

export default {
    setup() {
        const surveyReact = reactive({
            survey: {
                ID_Survey: 0,
                Title: '',
                Description: '',
                questions: []
            }
        });

        provide('surveyReact', surveyReact);

        return {
            surveyReact
        }

    },
    // provide() {
    //     return {
    //         survey: this.surveyReact.survey
    //     }
    // },
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
            this.$watchSurvey('surveyReact.survey.Title', this);
            this.$watchSurvey('surveyReact.survey.Description', this);
            this.$watchAll('surveyReact.survey', this);
        }

        if (this.$route.name === 'Create'){
            this.surveyReact.survey.ID_User = this.$route.params.ID_User;
            this.axios
                .post('survey', this.surveyReact.survey)
                .then(res => {
                    this.surveyReact.survey.ID_Survey = res.data;
                    watchEditor();
                    this.$router.replace(`editor/${res.data}`)
                })
                .catch(err => {
                    console.log(err);
                });

        }else {

            this.axios
                .get(`survey/${this.$route.params.ID_Survey}`)
                .then( res => {
                    
                    this.surveyReact.survey = this.$splitResulSet(res.data, [
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
                                'Description',
                                'Type',
                                'qOrder'
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
                    
                     
                    this.surveyReact.survey.questions.sort((a, b) => a.qOrder - b.qOrder);
                    
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
                .put(`survey/${this.surveyReact.survey.ID_Survey}`, this.surveyReact.survey)
                .then(resolve)
                .catch(err => {
                    console.log(err);
                });
        },

        createNewQuestionCard() {

            let id = 1;
            if (this.surveyReact.survey.questions.length > 0) {
                let sortArr = Array.from(this.surveyReact.survey.questions);
                sortArr.sort((a,b) => b.ID_Question - a.ID_Question);
                id = sortArr[0].ID_Question + 1;
            }

            let question = {
                ID_Question: id,
                Type: 'select',
                Question: '',
                qOrder: this.surveyReact.survey.questions.length,
                Description: '',
                answers: []
            }

            this.surveyReact.survey.questions.push(question);

            this.axios
                .post('survey/question', {
                    ID_Question: id,
                    Type: question.Type,
                    Question: question.Question,
                    qOrder: this.surveyReact.survey.questions.length,
                    Description: question.Description,
                    ID_Survey: this.surveyReact.survey.ID_Survey,
                })
                .then( res => {
                    console.log(res);
                })
                .catch(err => {
                    console.log(err);
                });

        },
        deleteQuestionCard(question) {
            this.surveyReact.survey.questions.splice( this.surveyReact.survey.questions.indexOf(question) , 1);

            this.axios
                .delete(`survey/question/${question.ID_Question}`, {
                    data: {
                        ID_Survey: this.surveyReact.survey.ID_Survey,
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


                let oldIndex = this.surveyReact.survey.questions.indexOf(this.draggedCard);

                if (newIndex === -1) {
                    newIndex = this.surveyReact.survey.questions.length;
                }
                if (newIndex < oldIndex) {
                    oldIndex++;
                }

                this.surveyReact.survey.questions.splice(newIndex, 0, this.draggedCard);
                this.surveyReact.survey.questions.splice(oldIndex, 1);

                this.draggedCard = null;

                for (let i=0; i<this.surveyReact.survey.questions.length; i++){
                    this.surveyReact.survey.questions[i].qOrder = i;
                }
            }
        },
        previewSurvey() {
            this.$router.push(`/user/${this.$route.params.ID_User}/survey/${this.$route.params.ID_Survey}`);
        },
        deleteSurvey() {
            this.axios
                .delete(`survey/${this.surveyReact.survey.ID_Survey}`)
                .then(res => {
                    console.log(res);
                    this.$router.push('/');
                })
                .catch(err => {
                    console.log(err);
                })
        },
        goToResults() {
            this.$router.push(`/user/${this.$route.params.ID_User}/results/${this.$route.params.ID_Survey}`);
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

    .editor__menu {
        border-radius: 0px;
    }

    .menu__upadate-status {
        width: 230px;
        text-align: center;
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
        margin: 20px 0;
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