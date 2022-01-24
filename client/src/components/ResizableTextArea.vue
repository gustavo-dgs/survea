<template>
    <textarea 
        class="resizable-textarea"
        @input="resizeTextArea($event)"
        rows="1"
        :value="modelValue"
    ></textarea>
</template>

<script>
    export default {
        props: {
            modelValue: String
        },
        emits: ['update:modelValue'],
        methods: {
            resizeTextArea (event){
                const textArea = event.target;
                textArea.style.height = "auto";
                textArea.style.height = (textArea.scrollHeight) + "px";
                this.$emit('update:modelValue', textArea.value);
            }
        }
    }
</script>

<style>
    .resizable-textarea {
        border: none;
        width: 100%;
        height: auto;
        padding: 0;
        margin: 0;
        word-wrap: break-word;
        resize: none;
        overflow-y: hidden;
        border-bottom: 3px solid #44974f00;
    }

    .resizable-textarea:focus{
        outline: none;
        background: #b6b5b59d;
        border-bottom: 3px solid #44974f;
    }
</style>