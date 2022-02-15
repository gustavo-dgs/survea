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
        emits: ['order-item'],
        methods: {
            drop(event){
                event.preventDefault();
                event.target.style.opacity = .2;
                this.$emit('order-item', this.index);
            }
        }
    }
</script>

<style>
    .dropzone {
        width: 100%;
        background:  #0bcccc;
        opacity: .2;
        height: 10px;
    }
</style>