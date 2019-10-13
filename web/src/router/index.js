import Vue from 'vue'
import Router from 'vue-router'
import ViewStaff from '@/components/staff/ViewStaff'
import EditStaff from '@/components/staff/EditStaff'
import ViewTests from '@/components/tests/ViewTests'
import AddTest from '@/components/tests/AddTest'
import EditTestDescription from '@/components/tests/EditTestDescription'
import ViewRecipes from '@/components/tests/recipes/ViewRecipes'
import ViewRecipeInfo from '@/components/tests/recipes/ViewRecipeInfo'
import NewRecipe from '@/components/tests/recipes/NewRecipe'
import EditRecipe from '@/components/tests/recipes/EditRecipe'
import ViewPrepLists from '@/components/tests/lists/ViewPrepLists'
import NewList from '@/components/tests/lists/NewList'
import ViewPrepList from '@/components/tests/lists/ViewPrepList'
import ViewPrepFaqs from '@/components/tests/faqs/ViewPrepFaqs'
import NewPrepFaq from '@/components/tests/faqs/NewPrepFaq'
import EditPrepFaq from '@/components/tests/faqs/EditPrepFaq'
import EditPrepList from '@/components/tests/lists/EditPrepList'
import ViewDailyCheckups from '@/components/tests/dailycheckups/ViewDailyCheckups'
import NewDailyCheckups from '@/components/tests/dailycheckups/NewDailyCheckups'
import ViewDailyCheckupsInfo from '@/components/tests/dailycheckups/ViewDailyCheckupsInfo'
import EditDailyCheckups from '@/components/tests/dailycheckups/EditDailyCheckups'
import ViewAppointments from '@/components/appointments/ViewAppointments'
import PastAppointments from '@/components/appointments/PastAppointments'
import AddAppointment from '@/components/appointments/AddAppointment'
import EditAppointment from '@/components/appointments/EditAppointment'
import ViewAppointment from '@/components/appointments/ViewAppointment'
import Login from '@/components/auth/Login'
import Register from '@/components/auth/Register'
import ResetPassword from '@/components/auth/ResetPassword'
import Message from '@/components/messages/Message'
import ViewArticles from '@/components/tests/articles/ViewArticles'
import AddArticle from '@/components/tests/articles/AddArticle'
import EditArticle from '@/components/tests/articles/EditArticle'
import firebase from 'firebase/app'
import 'firebase/auth'


Vue.use(Router)

let router = new Router({
  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: ViewAppointments,
      meta: {
        requiresAuth: true
      }
    },
    
    // Authentification routes

    {
      path: '/login',
      name: 'login',
      component: Login,
      meta: {
        requiresGuest: true
      }
    },
    {
      path: '/register',
      name: 'register',
      component: Register,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/resetPassword',
      name: 'resetPassword',
      component: ResetPassword,
      meta: {
        requiresGuest: true
      }
    },
    {
      path: '/edit-staff/:email',
      name: 'edit-staff',
      component: EditStaff,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-staff',
      name: 'view-staff',
      component: ViewStaff,
      meta: {
        requiresAuth: true
      }
    },
        
    // Appointment routes

    {
      path: '/view-appointments',
      name: 'view-appointments',
      component: ViewAppointments,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-appointment/:expired/:id',
      name: 'view-appointment',
      component: ViewAppointment,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/past-appointments',
      name: 'past-appointments',
      component: PastAppointments,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/add-appointment',
      name: 'add-appointment',
      component: AddAppointment,
      meta: {
        requiresAuth: true
      }
    },
    {

      path: '/edit-appointment/:expired/:id',
      name: 'edit-appointment',
      component: EditAppointment,
      meta: {
        requiresAuth: true
      }
    },
        
    // Message routes

    {

      path: '/message/:expired/:appointmentID',
      name: 'message',
      component: Message,
      meta: {
        requiresAuth: true
      }
    },
        
    // Test routes

    {
      path: '/add-test',
      name: 'add-test',
      component: AddTest,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/edit-test-description/:test_id',
      name: 'edit-test-description',
      component: EditTestDescription,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-tests',
      name: 'view-tests',
      component: ViewTests,
      meta: {
        requiresAuth: true
      }
    },
        
    // Article routes

    {
      path: '/view-articles/:test_id/:test_title',
      name: 'view-articles',
      component: ViewArticles,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/add-article/:test_id/:test_title',
      name: 'add-article',
      component: AddArticle,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/edit-article/:test_id/:article_id/:test_title',
      name: 'edit-article',
      component: EditArticle,
      meta: {
        requiresAuth: true
      }
    },
    
    // Recipe routes

    {
      path: '/view-recipes/:test_id',
      name: 'view-recipes',
      component: ViewRecipes,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-prep-lists/:test_id',
      name: 'view-prep-lists',
      component: ViewPrepLists,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/new-recipe/:test_id',
      name: 'new-recipe',
      component: NewRecipe,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/new-list/:test_id',
      name: 'new-list',
      component: NewList,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-recipe-info/:test_id/:recipe_id',
      name: 'view-recipe-info',
      component: ViewRecipeInfo,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-prep-list/:test_id/:contents',
      name: 'view-prep-list',
      component: ViewPrepList,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/new-prep-faq/:test_id/',
      name: 'new-prep-faq',
      component: NewPrepFaq,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/edit-prep-faq/:test_id/:faq_id',
      name: 'edit-prep-faq',
      component: EditPrepFaq,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-prep-faqs/:test_id/',
      name: 'view-prep-faqs',
      component: ViewPrepFaqs,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/edit-prep-list/:test_id/:contents',
      name: 'edit-prep-list',
      component: EditPrepList,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/edit-recipe/:test_id/:recipe_id',
      name: 'edit-recipe',
      component: EditRecipe,
      meta: {
        requiresAuth: true
      }
    },
        
    // Dailycheckup routes

    {
      path: '/view-dailycheckups/:test_id',
      name: 'view-dailycheckups',
      component: ViewDailyCheckups,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/new-dailycheckups/:test_id',
      name: 'new-dailycheckups',
      component: NewDailyCheckups,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/view-dailycheckups-info/:test_id/:daily_id',
      name: 'view-dailycheckups-info',
      component: ViewDailyCheckupsInfo,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: '/edit-dailycheckups/:test_id/:daily_id',
      name: 'edit-dailycheckups',
      component: EditDailyCheckups,
      meta: {
        requiresAuth: true
      }
    }
  ]
})

// Nav Guard

router.beforeEach((to, from, next) => {
  // Check for required auth guard
  if(to.matched.some(record => record.meta.requiresAuth)) {
    // Check if NOT logged in
    if(!firebase.auth().currentUser) {
      // Go to login page
      next({
        path: '/login',
        query: {
          redirect: to.fullPath
        }
      })
    }else {
      // Proceed to route
      next()
    }
  }else if(to.matched.some(record => record.meta.requiresGuest)) {
    // Check if logged in
    if(firebase.auth().currentUser) {
      // Go to Dashboard
      next({
        path: '/',
        query: {
          redirect: to.fullPath
        }
      })
    }else {
      // Proceed to route
      next()
    }
  }else {
    // Proceed to route
    next()
  }
})

export default router
