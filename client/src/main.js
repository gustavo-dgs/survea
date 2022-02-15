import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import axios from 'axios'
import VueAxios from 'vue-axios'
import watchPlugin from './plugins/watchPlugin'
import databasePlugin from './plugins/databasePlugin'
 
import ResizableTextArea from './components/ResizableTextArea.vue';
import Dropzone from './components/Dropzone.vue';
require('dotenv').config();
//import config from '../config';

// Agregamos la URL base de nuestra API
console.log(process.env);
axios.defaults.baseURL = `http://${process.env.VUE_APP_SERVER}`;
    
createApp(App).component('resizable-textarea', ResizableTextArea)
    .component('dropzone', Dropzone)
    .use(store)
    .use(router)
    .use(VueAxios, axios)
    .use(watchPlugin)
    .use(databasePlugin)
    .mount('#app');
