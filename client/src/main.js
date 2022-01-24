import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

import ResizableTextArea from './components/ResizableTextArea.vue';

createApp(App)
    .component('resizable-textarea', ResizableTextArea)
    .use(store)
    .use(router)
    .mount('#app');
