<template>
    <div class="options-list">

        <div class="options-list__options">

            <div class="options-list__wrapper" v-for="(option,i) of modelValue" :key="option">
                <ion-icon class="options-list__icon" :name="iconName"></ion-icon>
                <resizable-textarea
                    class="options-list__option"
                    placeholder="Write an option"
                    @input="updateOption()"
                    v-model="modelValue[i]"
                ></resizable-textarea>
                <ion-icon
                    class="options-list__icon options-list__icon--delete"
                    name="close-circle-outline"
                    @click="deleteOption(i)"
                ></ion-icon>
            </div>

        </div>
        

        <div 
            class="options-list__wrapper options-list__wrapper--create"
        >
            <ion-icon
                class="options-list__icon options-list__icon--create"
                name="create-outline"
            ></ion-icon>
            <resizable-textarea
                class="options-list__option options-list__option--create"
                placeholder="Write an option"
                @input="createOption($event)"
                v-model="createText"
            ></resizable-textarea>
        </div>
        
    </div>
</template>

<script>
    export default {
        data() {
            return {
                createText: ''
            }
        },
        props: {
            iconName: String,
            modelValue: Array
        },
        emits: ['update:modelValue'],
        methods: {
            createOption(event) {
                this.modelValue.push('');
                event.target.value = '';
            },
            deleteOption(i) {
                this.modelValue.splice(i, 1);
            },
            updateOption() {
                this.$emit('update:modelValue', this.modelValue);
            }
        },
        updated () {
            const node = document.querySelector('.options-list__options').lastElementChild;
            if (node !== undefined && node !== null) {
                const textArea = node.getElementsByClassName('options-list__option')[0];
                textArea.focus();
            }
            
        }
    }
</script>

<style>
    
    .options-list__options {
        width: 100%;
        display: flex;
        flex-direction: column;
    }

    .options-list__wrapper {
        width: 100%;
        display: flex;
        flex-direction: row;
        margin: 4px 0;
    }

    .options-list__icon {
        flex-grow: 0;
        font-size: 20px;
    }

    .options-list__icon--create {
        color: #44974f;
    }

    .options-list__icon--delete {
        color: #bb2924;
        cursor: pointer;
    }

    .options-list__option {
        flex-grow: 1;
        margin: 0 10px;
    }

</style>