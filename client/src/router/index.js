import { createRouter, createWebHistory } from 'vue-router'


const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue')
  },
  {
    path: '/create',
    name: 'Create',
    component: () => import('../views/Editor.vue')
  },
  {
    path: '/editor/:ID_Survey',
    name: 'Editor',
    component: () => import('../views/Editor.vue')
  },
  {
    path: '/survey/:ID_Survey',
    name: 'Survey',
    component: () => import('../views/Survey.vue')
  },
  {
    path: '/results/:ID_Survey',
    name: 'Results',
    component: () => import('../views/Results.vue')
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
