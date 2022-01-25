import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import axios from 'axios'
import VueAxios from 'vue-axios'
 
import ResizableTextArea from './components/ResizableTextArea.vue';

// Agregamos la URL base de nuestra API
axios.defaults.baseURL = 'http://localhost:4000/api';

createApp(App)
    .component('resizable-textarea', ResizableTextArea)
    .use(store)
    .use(router)
    .use(VueAxios, axios)
    .mount('#app');
