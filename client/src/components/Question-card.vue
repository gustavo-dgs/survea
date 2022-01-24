<template>

  <div class="question-card">

        <select class="question-card__select"
                v-model="question.type"
        >
            <option
                v-for="type of questionsTypesArr"
                :key="type"
                :value="type"
                class="select_opction"
            >
                {{ type }}
            </option>
        </select>
    
        <resizable-textarea
            class="question-card__title"
            placeholder="Question title"
            v-model="question.title"
        ></resizable-textarea>
        
        <hr/>

        <resizable-textarea
            class="question-card__description"
            placeholder="Question description"
            v-model="question.description"
        ></resizable-textarea>
        
        <!-- FORMS -->

        <div v-if="question.type === 'select'" class="question-form question-form--type--select">
            <options-list
                iconName="caret-down-circle-outline"
                :options="question.options"
            ></options-list>
        </div>

        <div v-else-if="question.type === 'checkbox'" class="question-form question-form--type--checkbox">
            <options-list
                iconName="checkbox-outline"
                :options="question.options"
            ></options-list>
        </div>

        <div v-else-if="question.type === 'radio'" class="question-form question-form--type--radio">
            <options-list
                iconName="ellipse-outline"
                :options="question.options"
            ></options-list>

        </div>

        <form v-else-if="question.type === 'textarea'" class="question-form question-form--type--textarea">
            <resizable-textarea
                class="question-form__textarea"
                placeholder="Write an awswer"
            ></resizable-textarea>
        </form>

        <form v-else-if="question.type === 'date'" class="question-form question-form--type--date">
            <input class="input date" type="date">
        </form>

        <form v-else-if="question.type === 'email'" class="question-form question-form--type--email">
            <input class="input email" type="email" placeholder="ingrese su correo electronico">
        </form>

        <form v-else-if="question.type === 'number'" class="question-form question-form--type--number">
            <input class="input number" type="number" placeholder="ingrese su numero">
        </form>

        <form v-else-if="question.type === 'text'" class="question-form question-form--type--text">
            <input class="input text" type="text" placeholder="ingrese un texto">
        </form>

        <form v-else-if="question.type === 'time'" class="question-form question-form--type--time">
            <input class="input time" type="time">
        </form>

        <form v-else-if="question.type === 'tel'" class="question-form question-form--type--tel">
            <input class="input tel" type="tel" placeholder="ingrese su numero de telefono" 
            pattern="[0-9]{3}-[0-9]{2}-[0-9]{3}">
        </form>

    </div>

</template>

<script>
    import OptionsList from '../components/OptionsList.vue'
    
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
            'options-list': OptionsList
        },
        methods: {
            saludar() {
                alert('HOla');
            }
        }
    }
</script>

<style>
    .question-card {
        background: #fff;
        border-radius: 20px;
        margin: 10px 0px;
        flex-basis: 100%;
        padding: 20px;
        display: flex;
        flex-direction: column;
    }

    .question-card > * {
        margin: 7px 0;
    }

    .question-card__select {
        align-self: center;
    }

    .question-card__title {
        font-size: 23px;
    }

    .question-card__description {
        font-size: 15px;
    }

    .question-form {
        width: 100%;
        display: flex;
        flex-direction: column;
    }

    .label {
        margin-left: 10px;
    }

    .textarea {
        resize: none;
    }
</style>