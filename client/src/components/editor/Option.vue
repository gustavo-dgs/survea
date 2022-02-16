<template>
    <div class="option">
        <ion-icon class="icon option__icon option__icon--form-type"
            :name="iconName"></ion-icon>

        <resizable-textarea class="option__resizable-textarea"
            ref="textArea"
            placeholder="Write an option"
            v-model="answer.Answer"
        ></resizable-textarea>

        <ion-icon class="icon icon--delete option__icon option__icon--delete"
            name="close-circle-outline"
            @click="deleteOption()"
        ></ion-icon>
    </div>
</template>

<script>
export default {
  inject: ['surveyReact'],
  props: {
    answer: Object,
    question: Object,
    iconName: String
  },
  emits: ['delete-option'],
  methods: {
    updateData (resolve) {
      this.axios
        .put(`survey/answer/${this.answer.ID_Answer}`, {
          ID_Question: this.question.ID_Question,
          ID_Survey: this.surveyReact.survey.ID_Survey,
          ID_User: this.surveyReact.survey.ID_User,
          Answer: this.answer.Answer,
          aOrder: this.answer.aOrder
        })
        .then(resolve)
        .catch(err => {
          console.log(err)
        })
    },
    deleteOption () {
      this.$emit('delete-option', this.answer)
    },
    focus () {
      this.$refs.textArea.focus()
    }
  },
  created () {
    this.$watchSurvey('answer.Answer', this)
  }
}
</script>

<style>
    .option {
        width: 100%;
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        margin: 3px 0;
        align-items: center;
    }

    .option:active {
        cursor: grabbing;
    }

    .option__icon {
        flex-grow: 0;
        width: 20px;
    }

    .option__resizable-textarea {
        flex-basis: 100px;
        flex-grow: 1;
        margin: 0 10px;
    }
</style>
