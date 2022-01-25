<template>
    <div class="options-list">

        <span> {{ options }} </span>

        <div class="options-list__options">

            <div class="options-list__wrapper" v-for="(option,i) of options" :key="option.ID_Answer">
                <ion-icon class="options-list__icon icon" :name="iconName"></ion-icon>

                <resizable-textarea
                    placeholder="Write an option"
                    class="options-list__option"
                    v-model="options[i].Answer"
                ></resizable-textarea>

                
                <ion-icon
                    class="options-list__icon icon icon--delete"
                    name="close-circle-outline"
                    @click="deleteOption(i)"
                ></ion-icon>
            </div>

        </div>

        <div 
            class="options-list__wrapper options-list__wrapper--create"
        >
            <ion-icon
                class="options-list__icon icon icon--create"
                name="create-outline"
            ></ion-icon>
            <resizable-textarea
                class="options-list__option options-list__option--create"
                placeholder="Write an option"
                @input="createOption($event)"
            ></resizable-textarea>
        </div>
        
    </div>
</template>

<script>
    export default {
        props: {
            iconName: String,
            options: Array
        },
        methods: {
            createOption(event) {
                this.options.push({});
                event.target.value = '';
            },
            deleteOption(i) {
                this.options.splice(0, 1);
                console.log(this.options);
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
        flex-direction: row;
        flex-wrap: wrap;
    }

    .options-list__wrapper {
        width: 100%;
        display: flex;
        flex-direction: row;
        
        margin: 4px 0;
    }

    .options-list__icon {
        flex-grow: 0;
    }

    .options-list__option {
        flex-grow: 1;
        margin: 0 10px;
    }

</style>