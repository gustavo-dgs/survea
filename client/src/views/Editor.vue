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
        </header>

       

        <div class="question-list">

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
                    :answers="answers.filter(x => x.ID_Question === q.ID_Question)"
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
                class="editor__button button button--primary"
                @click="createNewQuestionCard"
            >+
            </button>

        </div>

    </div>

</template>

<script>
import QuestionCard from '../components/Question-card.vue';
import Dropzone from '../components/Dropzone.vue';

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
                FinalDate: ''
            },
            questionArr: [],
            answers: []
        }
    },
    created() {

         // Cuando survey se actualice
        let watchSurvey = () => {
            this.$watch('survey', () => {
                if (this.lastTimeOut) {
                    clearTimeout(this.lastTimeOut);
                }
                this.updateStatus = 'Updating changes ...';
                this.lastTimeOut = setTimeout( this.updateSurvey, 3000);
                
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
                    watchSurvey();
                })
                .catch(err => {
                    console.log(err);
                });

        }else {

            this.axios
                .get(`survey/${this.$route.params.ID_Survey}`)
                .then( res => {
                    this.splitResulSet(res.data);
                    watchSurvey();
                })
                .catch(err => {
                    console.log(err);
                });

        }
        
    },
    components: {
        QuestionCard,
        'dropzone': Dropzone
    },
    methods: {
        updateSurvey() {
            this.axios
                .put(`survey/${this.survey.ID_Survey}`, this.survey)
                .then(res => {
                    this.lastTimeOut = null;
                    this.updateStatus = res.data;
                })
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
            
            for (let col in resulSet[0]) {
                this.survey[col] = resulSet[0][col];
            }
            
            for (let row of resulSet) {
                this.questionArr.push({
                    'ID_Question': row.ID_Question,
                    'Question': row.Question,
                    'Type': row.Type
                });

                this.answers.push({
                    'ID_Question': row.ID_Question,
                    'ID_Answer': row.ID_Answer,
                    'Answer': row.Answer,
                });
            }

            this.questionArr = removeDuplicates(this.questionArr, 'ID_Question');
        },
        createNewQuestionCard() {
            this.questionArr.push(new Question(this.questionsId++, this.questionArr.length));
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

                for (let i=0; i<this.questionArr.length; i++){
                    this.questionArr[i].order = i;
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