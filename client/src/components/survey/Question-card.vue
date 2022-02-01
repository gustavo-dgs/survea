<template>

  <div class="question-card survey__question-card">

        <div class="body">

            <resizable-textarea
                class="body__title"
                placeholder="Question title"
                v-model="question.Question"
                disabled
            ></resizable-textarea>
            
            <hr/>

            <resizable-textarea
                class="body__description"
                placeholder="Question description"
                v-model="question.Description"
                disabled
            ></resizable-textarea>
            

            <form class="question-form question-form--type--select"
                v-if="question.Type === 'select'" 
            >
                <select class="input select"
                    v-model="question.Answer"
                >
                    <option 
                        class="select__opction"
                        v-for="answer of question.answers"
                        :key="answer.Answer"
                        :value="answer.Answer"
                        
                    >
                        {{ answer.Answer }}
                    </option>
                </select>
            </form>

            <form class="question-form quesquestion-form--type--checkbox"
                v-else-if="question.Type === 'checkbox'"
            >
                <div class="option"
                    v-for="answer of question.answers" :key="answer.Answer"
                >
                    <input class="input checkbox"
                        type="checkbox"
                        :value="answer.Answer"
                        @click="pushAnswer($event, answer.Answer)"
                    >
                    <label class="label" 
                        :for="answer.Answer"
                    >{{ answer.Answer }}</label>
                </div>
            </form>

            <form class="question-form question-form--type--radio"
                v-else-if="question.Type === 'radio'"
            >
                <div class="option"
                    v-for="answer of question.answers" :key="answer.Answer"
                >
                    <input class="input radio" 
                        name="radio_option" 
                        type="radio" 
                        :value="answer.Answer"
                        v-model="question.Answer"
                    >
                    <label class="label" 
                        for="radio_option"
                    >{{ answer.Answer }}</label>
                </div>
            </form>

            <form v-else-if="question.Type === 'textarea'" class="question-form question-form--type--textarea">
                <resizable-textarea
                    class="question-form__textarea"
                    placeholder="Write an awswer"
                    v-model="question.Answer"
                ></resizable-textarea>
            </form>

            <form v-else-if="question.Type === 'date'" class="question-form question-form--type--date">
                <input class="input date"
                    type="date"
                    v-model="question.Answer"
                >
            </form>

            <form v-else-if="question.Type === 'email'" class="question-form question-form--type--email">
                <input class="input email" 
                    type="email" 
                    placeholder="ingrese su correo electronico"
                    v-model="question.Answer"
                >
            </form>

            <form v-else-if="question.Type === 'number'" class="question-form question-form--type--number">
                <input class="input number" 
                    type="number" 
                    placeholder="ingrese su numero"
                    v-model="question.Answer"
                >
            </form>

            <form v-else-if="question.Type === 'text'" class="question-form question-form--type--text">
                <input class="input text"
                    type="text"
                    placeholder="ingrese un texto"
                    v-model="question.Answer"
                >
            </form>

            <form v-else-if="question.Type === 'time'" class="question-form question-form--type--time">
                <input class="input time" 
                    type="time"
                    v-model="question.Answer"
                >
            </form>

            <form v-else-if="question.Type === 'tel'" class="question-form question-form--type--tel">
                <input class="input tel" 
                    type="tel" 
                    placeholder="ingrese su numero de telefono" 
                    pattern="[0-9]{3}-[0-9]{2}-[0-9]{3}"
                    v-model="question.Answer"
                >
            </form>

      </div>
        
    </div>

</template>

<script>
    import QuestionCard from '../editor/Question-card.vue'
    import Option from '../editor/Option.vue'

    export default {
        data() {
            return {
                questionsTypesArr: ['select', 'checkbox', 'radio', 'text', 
                                    'textarea', 'date', 'email','number', 
                                    'time', 'tel']
            }
        },
        props: {
            question: Object
        },
        components: {
            QuestionCard,
            Option
        },
        methods: {
            pushAnswer(event, answer) {
                
                if (event.target.checked) {
                    this.question.Answer = this.question.Answer + answer + ',';
                }else{
                    this.question.Answer = this.question.Answer
                        .replace(answer+',' , '');
                }
            }
        },
        created() {
            this.question.Answer = '';
        }
    }
</script>

<style>
    .survey__question-card {
        display: flex;
        flex-direction: column;
    }

    .option:active {
        cursor: none;
    }

    .label {
        margin-left: 10px;
    }

</style>