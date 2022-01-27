<template>
    <div class="options-list">

        <template
            v-for="(option,i) of options" 
            :key="option.ID_Answer"
        >

            <dropzone class="option-list__dropzone"
                v-show="isDropzoneVisible"
                :index="i"
                @order-item="orderOption($event)"
            ></dropzone>

            <Option class="option-list__option"
                :answer="options[i]"
                :question="question"
                :ref="setItemRef"
                :iconName="iconName"
                draggable="true"
                @dragstart="dragStart($event)"
                @dragend="dragEnd($event)"
                @delete-option="deleteOption($event)"
            />

        </template>

        <dropzone class="option-list__dropzone"
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
    import Option from '../components/Option.vue'

    export default {
        data() {
            return {
                itemRefs: [],
                isNewOptionCreated: false,
                firstLetter: '',
                isDropzoneVisible: false,
                draggedOption: null,
            }
        },
        components: {
            Option
        },
        props: {
            iconName: String,
            options: Array,
            question: Object
        },
        inject: ['watchSurvey', 'survey'],
        methods: {

            createOption(event) {

                this.firstLetter =  event.target.value;
                event.target.value = '';
                this.isNewOptionCreated = true;

                let id = 1;
                if (this.options.length > 0) {
                    let sortArr = Array.from(this.options);
                    sortArr.sort((a, b) => b.ID_Answer - a.ID_Answer);
                    id = sortArr[0].ID_Answer + 1;
                }

                let answer = {
                    ID_Answer: id, 
                    Answer: this.firstLetter,
                    aOrder: this.options.length
                }

                this.options.push(answer);
            
                this.axios
                .post('survey/answer', {
                    ID_Question: this.question.ID_Question,
                    ID_Survey: this.survey.ID_Survey,
                    ID_User: this.survey.ID_User,
                    ID_Answer: answer.ID_Answer,
                    Answer: answer.Answer,
                    aOrder: answer.aOrder
                })
                .then( res => {                            
                    console.log(res);
                })
                .catch(err => {
                    console.log(err);
                });

            },

            deleteOption(answer) {
                this.options.splice(this.options.indexOf(answer), 1);

                
                this.axios
                    .delete(`survey/answer/${answer.ID_Answer}`, {
                        data: {
                            ID_Question: this.question.ID_Question,
                            ID_Survey: this.survey.ID_Survey,
                            ID_User: this.survey.ID_User
                        }
                    })
                    .then(res => {
                        console.log(res);
                    })
                    .catch(err => {
                        console.log(err);
                    });
              

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
              
                this.itemRefs[this.itemRefs.length - 1].focus();
                this.isNewOptionCreated = false;
                
                // const resizableTextarea = node.querySelector('.option__resizable-textarea');
                // resizableTextarea.value = this.firstLetter;
                // resizableTextarea.focus();
            }
        }
    }
</script>

<style>
    .options-list {
        display: flex;
        flex-direction: column;
    }

    .option-list_option {
        outline: 1px solid red;
    }

    .option-list__dropzone {
        width: 100%;
        margin: 3px 0;
    }

</style>