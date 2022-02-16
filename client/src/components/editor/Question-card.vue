<template>

    <div class="question-card"
        @dragstart="dragStart($event)"
        @dragend="dragEnd($event)"
        draggable="true"
    >
        <div class="toolbar">
            <ion-icon
                class="toolbar__icon icon"
                name="apps"
                @click="showMenu($event)"
            ></ion-icon>
        </div>

        <div class="menu question-card__menu"
            :style="menuStyle"
        >
            <ion-icon
                class="menu__copy icon icon--secundary"
                name="copy"
            ></ion-icon>

            <select class="menu__select"
                v-model="question.Type"
            >
                <option class="menu__option"
                    v-for="type of questionsTypesArr"
                    :key="type"
                    :value="type"
                >
                    {{ type }}
                </option>
            </select>

            <ion-icon class="menu__delete icon icon--delete"
                name="trash"
                @click="$emit('delete-question-card', question)"
            ></ion-icon>

        </div>

        <div class="body">

            <resizable-textarea
                class="body__title"
                placeholder="Question title"
                v-model="question.Question"
                draggable="false"
            ></resizable-textarea>

            <hr/>

            <resizable-textarea
                class="body__description"
                placeholder="Question description"
                v-model="question.Description"
            ></resizable-textarea>

            <!-- FORMS -->

            <div v-if="question.Type === 'select'" class="question-form question-form--type--select">
                <options-list
                    iconName="caret-down-circle-outline"
                    :options="question.answers"
                    :question="question"
                ></options-list>
            </div>

            <div v-else-if="question.Type === 'checkbox'" class="question-form question-form--type--checkbox">
                <options-list
                    iconName="checkbox-outline"
                    :options="question.answers"
                    :question="question"
                ></options-list>
            </div>

            <div v-else-if="question.Type === 'radio'" class="question-form question-form--type--radio">
                <options-list
                    iconName="ellipse-outline"
                    :options="question.answers"
                    :question="question"
                ></options-list>

            </div>

            <form v-else-if="question.Type === 'textarea'" class="question-form question-form--type--textarea">
                <resizable-textarea
                    class="question-form__textarea"
                    placeholder="Write an awswer"
                    disabled
                ></resizable-textarea>
            </form>

            <form v-else-if="question.Type === 'date'" class="question-form question-form--type--date">
                <resizable-textarea
                    class="question-form__textarea"
                    placeholder="Write a date"
                    disabled
                ></resizable-textarea>
            </form>

            <form v-else-if="question.Type === 'email'" class="question-form question-form--type--email">
                <resizable-textarea
                    class="question-form__textarea"
                    placeholder="ingrese su correo electronico"
                    disabled
                ></resizable-textarea>
            </form>

            <form v-else-if="question.Type === 'number'" class="question-form question-form--type--number">
                <resizable-textarea
                    class="question-form__textarea"
                    placeholder="ingrese un numero"
                    disabled
                ></resizable-textarea>
            </form>

            <form v-else-if="question.Type === 'text'" class="question-form question-form--type--text">
                <resizable-textarea
                    class="question-form__textarea"
                    placeholder="ingrese un texto corto"
                    disabled
                ></resizable-textarea>
            </form>

            <form v-else-if="question.Type === 'time'" class="question-form question-form--type--time">
                <resizable-textarea
                    class="question-form__textarea"
                    placeholder="ingrese una hora"
                    disabled
                ></resizable-textarea>
            </form>

            <form v-else-if="question.Type === 'tel'" class="question-form question-form--type--tel">
                <resizable-textarea
                    class="question-form__textarea"
                    placeholder="ingrese su numero de telefono"
                    disabled
                ></resizable-textarea>
            </form>

        </div>

    </div>

</template>

<script>
import OptionsList from './OptionsList.vue'

export default {
  data () {
    return {
      questionsTypesArr: ['select', 'checkbox', 'radio', 'text',
        'textarea', 'date', 'email', 'number',
        'time', 'tel'],
      menuStyle: {
        display: 'none',
        top: 0,
        bottom: 0
      },
      isDraggable: false,
      lastTimeOut: null
    }
  },
  emits: [
    'delete-question-card',
    'show-dropzones',
    'hide-dropzones',
    'dragged-card'
  ],
  props: {
    question: Object
  },
  components: {
    'options-list': OptionsList
  },
  inject: ['surveyReact'],
  methods: {
    showMenu () {
      if (this.menuStyle.display === 'none') {
        this.menuStyle.display = 'flex'
      } else {
        this.menuStyle.display = 'none'
      }
    },
    dragStart (event) {
      event.target.style.opacity = 0.2
      event.dataTransfer.setData('text/plain', null)
      this.$emit('show-dropzones')
      this.$emit('dragged-card', this.question)
    },
    dragEnd (event) {
      event.target.style.opacity = 1
      this.isDraggable = false
      this.$emit('hide-dropzones')
    },
    updateData (resolve) {
      this.axios
        .put(`survey/question/${this.question.ID_Question}`, {
          Type: this.question.Type,
          Question: this.question.Question,
          qOrder: this.question.qOrder,
          Description: this.question.Description,
          ID_Survey: this.surveyReact.survey.ID_Survey
        })
        .then(resolve)
        .catch(err => {
          console.log(err)
        })
    }
  },
  created () {
    const properties = ['Question', 'Type', 'qOrder', 'Description']
    for (const p of properties) {
      this.$watchSurvey('question.' + p, this)
    }
  }
}
</script>

<style>
    .question-card {
        background: #fff;
        border-radius: 20px;
        width: 100%;
        display: grid;
        grid-template-columns: max-content 1fr;
        grid-template-rows: max-content max-content;
        transition: 0.3s;
    }

    .toolbar {
        background: #0bcccc;
        border-radius: 20px 0 0 20px;
        width: 30px;
        display: flex;
        flex-direction: row;
        justify-content: center;
        align-items: center;
        grid-row: 1/-1;
    }

    .toolbar__icon {
        cursor: grab;
        font-weight: 500;
        color: #fff;
    }

    .toolbar__icon:active {
        cursor: grabbing;
    }

    .question-card__menu {
        border-radius: 0 20px 0 0;
    }

    .menu__select {
        min-width: 200px;
    }

    .body {
        display: flex;
        flex-direction: column;
        flex-grow: 1;
        padding: 20px;
    }

    .body > * {
        margin: 7px 0;
    }

    .body__title {
        font-size: 23px;
    }

    .body__description {
        font-size: 15px;
    }

    .question-form {
        width: 100%;
        display: flex;
        flex-direction: column;
    }

</style>
