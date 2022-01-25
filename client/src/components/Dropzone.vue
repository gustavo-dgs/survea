<template>
    <div class="dropzone"
        @dragover="$event.preventDefault()"
        @dragenter="$event.target.style.opacity = 1"
        @dragleave="$event.target.style.opacity = .2"
        @drop="drop($event)"
    ></div>
</template>

<script>
    export default {
        props: {
            index: Number,
        },
        emits: ['order-question-card'],
        methods: {
            drop(event){
                event.preventDefault();
                event.target.style.opacity = .2;

                const obj = {
                    question: this.question,
                    index: this.index
                };
                this.$emit('order-question-card', this.index);
            }
        }
    }
</script>

<style>
    .dropzone {
        width: 100%;
        background:  #0bcccc;
        opacity: .2;
        height: 4px;
    }
</style>