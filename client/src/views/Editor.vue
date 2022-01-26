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

            <span> {{ this.survey.questions }} </span>
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

export default {
    data() {
        return {
            questionsId: 0,
            isDropzoneVisible: false,
            draggedCard: null,
            updateStatus: 'All save',
            lastTimeOut: null,
            survey: {
                ID_Survey: 0,
                Title: '',
                Description: '',
                ID_User: 1,
                StartDate: '',
                FinalDate: '',
                Order: 0,
                questions: []
            },
        }
    },
    created() {

        // Cuando survey se actualice
        let watchSurvey = (property, callback) => {
            this.$watch(property, () => {
                if (this.lastTimeOut) {
                    clearTimeout(this.lastTimeOut);
                }
                this.updateStatus = 'Updating changes ...';
                this.lastTimeOut = setTimeout( () => callback( res => {
                    this.lastTimeOut = null;
                    this.updateStatus = res.data;
                }), 3000);
                
            }, {
                flush: 'post',
            });
        };

        if (this.$route.name === 'Create'){

            this.axios
                .post('survey', this.survey)
                .then(res => {
                    this.survey.ID_Survey = res.data;
                    watchSurvey('survey.Title', this.updateSurvey);
                    watchSurvey('survey.Description', this.updateSurvey);
                })
                .catch(err => {
                    console.log(err);
                });

        }else {

            this.axios
                .get(`survey/${this.$route.params.ID_Survey}`)
                .then( res => {
                    this.splitResulSet(res.data);
                    watchSurvey('survey.Title', this.updateSurvey);
                    watchSurvey('survey.Description', this.updateSurvey);
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
        updateSurvey(resolve) {
            this.axios
                .put(`survey/${this.survey.ID_Survey}`, this.survey)
                .then(resolve)
                .catch(err => {
                    console.log(err);
                });
        },
        splitResulSet(resulSet) {

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
                    'Order': row.qOrder,
                    'Description': row.qDescription
                });

                answers.push({
                    'ID_Question': row.ID_Question,
                    'ID_Answer': row.ID_Answer,
                    'Answer': row.Answer,
                    'Order': row.aOrder
                });
            }

            questionArr = removeDuplicates(questionArr, 'ID_Question');
            questionArr = includeArray(questionArr, answers, 'answers', 'ID_Question');
            this.survey.questions = questionArr;


            let sortArr = Array.from(questionArr);
            sortArr.sort((a,b) => b.ID_Question - a.ID_Question)
            this.questionsId = questionArr[0].ID_Question + 1;
            this.questionsOrder = sortArr.length;
        },
        createNewQuestionCard() {
            let question = {
                ID_Question: this.questionsId++,
                Type: 'select',
                answers: []
            }
            this.survey.questions.push(question);
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
                    this.survey.questions[i].Order = i;
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