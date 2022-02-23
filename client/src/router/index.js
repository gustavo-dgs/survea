import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/user/:ID_User',
    name: 'User',
    component: () => import('../views/User.vue'),
    children: [
      {
        path: '',
        name: 'Home',
        component: () => import('../views/Home.vue')
      },
      {
        path: 'create',
        name: 'Create',
        component: () => import('../views/Editor.vue')
      },
      {
        path: 'editor/:ID_Survey',
        name: 'Editor',
        component: () => import('../views/Editor.vue')
      },
      {
        path: 'preview-survey/:ID_Survey',
        name: 'Preview',
        component: () => import('../views/Survey.vue')
      },
      {
        path: 'results/:ID_Survey',
        name: 'Results',
        component: () => import('../views/Results.vue')
      }
    ]
  },
  {
    path: '/',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/survey/ID_Surey',
    name: 'Survey',
    component: () => import('../views/Survey.vue')
  },
  { path: '/:pathMatch(.*)*', 
    name: 'NotFound', 
    component: () => import('../views/NotFound.vue') 
  }
  
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
