<template>
    <div class="options-list">

        <template class="options-list__wrapper"
            v-for="(option,i) of options" 
            :key="option.ID_Answer"
        >

            <dropzone class="option__dropzone"
                v-show="isDropzoneVisible"
                :index="i"
                @order-item="orderOption($event)"
            ></dropzone>

            <div class="option"  
                :ref="setItemRef"
                draggable="true"
                @dragstart="dragStart($event)"
                @dragend="dragEnd($event)"
            >
                <ion-icon class="icon option__icon option__icon--form-type" 
                    :name="iconName"></ion-icon>

                <resizable-textarea class="option__resizable-textarea"
                    placeholder="Write an option"
                    v-model="options[i].Answer"
                ></resizable-textarea>

                
                <ion-icon class="icon icon--delete option__icon option__icon--delete"
                    name="close-circle-outline"
                    @click="deleteOption(i)"
                ></ion-icon>
            </div>

        </template>

        <dropzone class="option__dropzone"
            v-show="isDropzoneVisible"
            :index="-1"
            @order-item="orderOption($event)"
        ></dropzone>

        <div 
            class="option option--create"
        >
            <ion-icon
                class="option__icon icon icon--create"
                name="create-outline"
            ></ion-icon>
            <resizable-textarea
                class="option__resizable-textarea option__resizable-textarea--create"
                placeholder="Write an option"
                @input="createOption($event)"
            ></resizable-textarea>
        </div>
        
    </div>
</template>

<script>
    export default {
        data() {
            return {
                itemRefs: [],
                isNewOptionCreated: false,
                firstLetter: '',
                isDropzoneVisible: false,
                draggedOption: null
            }
        },
        props: {
            iconName: String,
            options: Array
        },
        methods: {
            createOption(event) {
                this.firstLetter =  event.target.value;
                event.target.value = '';
                this.isNewOptionCreated = true;
                this.options.push({});
            },
            deleteOption(i) {
                this.options.splice(i, 1);
                console.log(i, this.options);
            },
            setItemRef(el) {
                if (el) {
                    this.itemRefs.push(el);
                }
            },
            dragStart(event) {
                this.isDropzoneVisible = true;
            },
            dragEnd(event) {
                this.isDropzoneVisible = false;
            },
            orderOption(newIndex) {
                // if (this.draggedOption !== null){

                //     let oldIndex = this.options.indexOf(this.draggedOption);

                //     if (newIndex === -1) {
                //         newIndex = this.options.length;
                //     }
                //     if (newIndex < oldIndex) {
                //         oldIndex++;
                //     }

                //     this.options.splice(newIndex, 0, this.draggedOption);
                //     this.options.splice(oldIndex, 1);

                //     this.draggedOption = null;

                //     for (let i=0; i<this.options.length; i++){
                //         this.options[i].Order = i;
                //     }
                // }
            }
        },
        beforeUpdate() {
            this.itemRefs = [];
        },
        updated () {
            if (this.isNewOptionCreated) {
              
                const node = this.itemRefs[this.itemRefs.length - 1];
                const resizableTextarea = node.querySelector('.option__resizable-textarea');
                resizableTextarea.value = this.firstLetter;
                resizableTextarea.focus();
                this.isNewOptionCreated = false;
            }
        }
    }
</script>

<style>
    .options-list {
        display: flex;
        flex-direction: column;
    }

    .options-list__wrapper {
        width: 100%;
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
    }

    .option {
        width: 100%;
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        margin: 3px 0;
    }

    .option:active {
        cursor: grabbing;
    }

    .option__dropzone {
        width: 100%;
        margin: 3px 0;
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