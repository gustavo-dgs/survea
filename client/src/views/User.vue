<template>
    <div class="user">
        <Header class="user__header"/>
        <router-view class="user__router-view"/>
    </div>
</template>

<script>
import Header from '../components/Header.vue'

export default {
    components: {
        Header
    }
}
</script>

<style>

</style>