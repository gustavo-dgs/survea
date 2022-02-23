<template>

    <div class="survey">

        <header class="survey__header">

            <resizable-textarea class="survey__title"
                v-model="survey.Title"
                placeholder="Survey Title"
                disabled
            ></resizable-textarea>

            <resizable-textarea class="survey__description"
                v-model="survey.Description"
                placeholder="Survey Description"
                disabled
            ></resizable-textarea>

        </header>

        <div class="question-list">

            <div class="question-list__inner"
                v-for="q of this.survey.questions"
                :key="q.ID_Survey"
            >

                <QuestionCard class="question-list__question-card"
                    :question="q"
                />

            </div>

            <button
                class="survey__button button button--primary"
                @click="saveSurvey"
                v-if="$route.name !== 'Preview'"
            >Finish Survey
            </button>

        </div>

    </div>

</template>

<script>
import QuestionCard from '../components/survey/Question-card.vue'
import { provide, reactive, toRefs } from 'vue'

export default {
  setup () {
    const surveyReact = reactive({
      survey: {}
    })

    const { survey } = toRefs(surveyReact)

    provide('survey', survey)

    return {
      survey
    }
  },
  created () {
    this.axios.get(`survey/${this.$route.params.ID_Survey}`)
      .then(res => {
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
              'Type'
            ]
          },
          {
            thisId: 'ID_Answer',
            linkId: 'ID_Question',
            columns: [
              'ID_Answer',
              'Answer'
            ]
          }
        ])[0]
      }).catch(err => {
        console.log(err)
      })
  },
  components: {
    QuestionCard
  },

  methods: {
    saveSurvey () {
      function checkQuestions (value, index, array) {
        return value.Answer === ''
      }

      if (this.survey.questions.some(checkQuestions)) {
        alert('The Survey is not complete')
      } else {
        this.axios
          .post('/surveyed', {
            ID_Survey: this.survey.ID_Survey,
            ID_User: this.survey.ID_User
          })
          .then(async res => {
            for (const question of this.survey.questions) {
              await this.axios.post('surveyed/answer', {
                Answer: question.Answer,
                ID_Question: question.ID_Question,
                ID_Survey: this.survey.ID_Survey,
                ID_User: this.survey.ID_User,
                ID_Surveyed: res.data
              })
            }

            this.$router.push(`/user/${this.$route.params.ID_User}/editor/${this.survey.ID_Survey}`)
          })
          .catch(err => {
            console.log(err)
          })
      }
    }
  }
}
</script>

<style>

    .survey {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 100%;
    }

    .survey > * {
        width: 100%;
    }

    .survey__header {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 20px;
        width: 100%;
        padding: 10px;
        background: #fff;
    }

    .survey__header > * {
        margin: 5px 0;
    }

    .survey__title {
        font-size: 30px;
    }

    .survey__description {
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

    .question-list__inner {
        width: 100%;
        display: flex;
        flex-direction: column;
    }

    .question-list__question-card {
        margin: 10px 0px;
    }

    .survey__button {
        width: 100%;
        font-size: 20px;
        margin-top: 15px;
    }

</style>
