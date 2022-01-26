<template>

    <div class="editor">

        <header class="editor__header">

            <h4 class="editor__upadate-status">
                {{ updateStatus }}
            </h4>

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
            >+
            </button>

        </div>

    </div>

</template>

<script>
import QuestionCard from '../components/Question-card.vue';
import { provide, reactive,  readonly } from 'vue'

export default {
    setup() {
        const survey= reactive({
            ID_Survey: 0,
            Title: 'untitle',
            Description: '',
            ID_User: 1,
            StartDate: new Date,
            FinalDate: new Date,
            questions: []
        });

        provide('survey', survey);

        return {
            survey
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

        let watchAll = () => {
            this.$watch('survey', () => {
                if (this.lastStatusTimeOut) {
                    clearTimeout(this.lastStatusTimeOut);
                }
                this.updateStatus = 'Updating changes ...';
                this.lastStatusTimeOut = setTimeout( () => {
                    this.lastStatusTimeOut = null;
                    this.updateStatus = 'All save';
                }, 3000);
                
            }, {
                deep: true,
                flush: 'post',
            });
        };

        if (this.$route.name === 'Create'){

            this.axios
                .post('survey', this.survey)
                .then(res => {
                    this.survey.ID_Survey = res.data;
                    this.watchSurvey('survey.Title', this);
                    this.watchSurvey('survey.Description', this);
                    watchAll();
                })
                .catch(err => {
                    console.log(err);
                });

        }else {

            this.axios
                .get(`survey/${this.$route.params.ID_Survey}`)
                .then( res => {
                    this.splitResulSet(res.data);
                    this.watchSurvey('survey.Title', this);
                    this.watchSurvey('survey.Description', this);
                    watchAll();
                })
                .catch(err => {
                    console.log(err);
                });

        }
    },
    components: {
        QuestionCard
    },
    provide() {
        return {
            watchSurvey: this.watchSurvey,
        }
    },
    methods: {
        watchSurvey(property, vue, deepValue) {
            let options = {flush: 'post', deep: deepValue ? true : false}
            vue.$watch(property, (newVal, oldVal) => {
                if (vue.lastTimeOut) {
                    clearTimeout(vue.lastTimeOut);
                }
                vue.lastTimeOut = setTimeout( () => vue.updateData( res => {
                    vue.lastTimeOut = null;
                    console.log(res.data);
                }, newVal, oldVal), 3000);
                
            }, options);
        },

        updateData(resolve) {
            
            this.axios
                .put(`survey/${this.survey.ID_Survey}`, this.survey)
                .then(resolve)
                .catch(err => {
                    console.log(err);
                });
        },
        splitResulSet(resulSet) {

            console.log(resulSet);

            let removeDuplicates = (originalArr, property) => {
                let newArr = [];
                for (let item of originalArr) {
                    if (newArr.findIndex(x => x[property] === item[property]) === -1) {
                        newArr.push(item)
                    }
                }
                return newArr;
            };

            let includeArray = (firstArray, secondArray, propertyName, link) => {
                for (let i=0; i<firstArray.length; i++) {
                    firstArray[i][propertyName] = secondArray.filter(x => x[link] === firstArray[i][link]);
                }

                for (let i=0; i<firstArray.length; i++) {
                    for (let j=0; j<firstArray[i][propertyName].length; j++){
                        delete firstArray[i][propertyName][j][link];  
                    }
                }

                return firstArray;
            };
            
            for (let col in resulSet[0]) {
                this.survey[col] = resulSet[0][col];
            }
            
            let questionArr = [];
            let answers = [];
            for (let row of resulSet) {
                
                questionArr.push({
                    'ID_Question': row.ID_Question,
                    'Question': row.Question,
                    'Type': row.Type,
                    'qOrder': row.qOrder,
                    'Description': row.qDescription
                });

                answers.push({
                    'ID_Question': row.ID_Question,
                    'ID_Answer': row.ID_Answer,
                    'Answer': row.Answer,
                    'aOrder': row.aOrder
                });
            }

            questionArr = removeDuplicates(questionArr, 'ID_Question');
            questionArr = includeArray(questionArr, answers, 'answers', 'ID_Question');
            this.survey.questions = questionArr;


            let sortArr = Array.from(questionArr);
            sortArr.sort((a,b) => b.ID_Question - a.ID_Question);
            this.questionsId = sortArr[0].ID_Question + 1;
        },
        createNewQuestionCard() {
            let question = {
                ID_Question: this.questionsId++,
                Type: 'select',
                Question: 'untitle',
                ID_Survey: this.survey.ID_Survey,
                ID_User: this.survey.ID_User,
                qOrder: this.survey.questions.length,
                Description: null
            }

            this.axios
                .post('survey/question', question)
                .then( res => {
                    //console.log(res);
                    question.answers = [];
                    //delete question.ID_Survey;
                    //delete question.ID_User
                    this.survey.questions.push(question);
                })
                .catch(err => {
                    //console.log(err);
                });
        },
        deleteQuestionCard(question) {
            this.survey.questions.splice( this.survey.questions.indexOf(question) , 1);
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
        border-radius: 30px;
        font-size: 30px;
        color: white;
        margin-top: 15px;
    }

</style>