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
        

        <form v-if="question.type === 'select'" class="question-form question-form--type--select">
            <select class="input select">
                <option 
                    class="select_opction"
                    v-for="option of question.options"
                    :key="option"
                    :value="option"
                >
                    {{ option }}
                </option>
            </select>
        </form>

        <form v-else-if="question.type === 'textarea'" class="question-form question-form--type--textarea">
            <textarea class="input textarea" placeholder="Escriba su respuesta"></textarea>
        </form>

        <form v-else-if="question.type === 'checkbox'" class="question-form question-form--type--checkbox">
            
            <template v-for="option of question.options" :key="option">
                <input class="input checkbox" type="checkbox" :value="option">
                <label class="label" :for="option"> {{ option }} </label><br>
            </template>
            
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

        <form v-else-if="question.type === 'radio'" class="question-form question-form--type--radio">
            <template v-for="option of question.options" :key="option">
                <!-- <input class="input radio" :name="option" type="radio" :value="option">
                <label class="label" :for="option"> {{ option }} </label><br> -->
                <i class="fa-regular fa-circle"></i>
                <resizable-textarea
                    class="question-form__option"
                    placeholder="Write an option"
                ></resizable-textarea>
            </template>
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
    import ResizableTextArea from '../components/ResizableTextArea.vue'
    
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
            // 'resizable-textarea': () => import('../components/ResizableTextArea.vue')
            'resizable-textarea': ResizableTextArea
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

    .label {
        margin-left: 10px;
    }

    .textarea {
        resize: none;
    }
</style>