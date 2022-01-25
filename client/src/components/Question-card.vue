<template>

    <div class="question-card"
        :draggable="isDraggable"
        @dragstart="dragStart($event)"
        @dragend="dragEnd($event)"
    >
        <div class="toolbar">
            <ion-icon 
                class="toolbar__icon icon" 
                name="apps"
                @click="showMenu($event)"
                @mousedown="isDraggable=true"
            ></ion-icon>
        </div>

        <div class="menu"
            :style="menuStyle"
        >
            <ion-icon
                class="menu__copy icon icon--secundary"
                name="copy"
            ></ion-icon>
            
            <select class="menu__select"
                v-model="question.type"
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
                v-model="question.title"
            ></resizable-textarea>
            
            <hr/>

            <resizable-textarea
                class="body__description"
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

    </div>

        

</template>

<script>
    import OptionsList from '../components/OptionsList.vue'
    
    export default {
        data() {
            return {
                questionsTypesArr: ['select', 'checkbox', 'radio', 'text', 
                                    'textarea', 'date', 'email','number', 
                                    'time', 'tel'],
                menuStyle: {
                    display: 'none',
                    top: 0,
                    bottom: 0
                },
                isDraggable: false
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
        methods: {
            showMenu() {
                if ( this.menuStyle.display === 'none') {
                    this.menuStyle.display = 'flex';
                } else {
                    this.menuStyle.display = 'none';
                }
            },
            dragStart(event) {
                event.target.style.opacity = .2;
                this.$emit('show-dropzones');
                this.$emit('dragged-card', this.question);
            },  
            dragEnd(event) {
                event.target.style.opacity = 1;
                this.isDraggable = false;
                this.$emit('hide-dropzones');
            }
        },
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
        width: 26px;
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

    .menu {
        width: 100%;
        display: flex;
        flex-direction: row;
        justify-content: space-around;
        align-items: center;
        background: #e0e3e7;
        padding: 10px;
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