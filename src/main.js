import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import vuetify from './plugins/vuetify'
import VueClipboard from 'vue-clipboard2'
import plugins from '@/plugins'
import Toast from './components/toast'


Vue.config.productionTip = false
Vue.use(VueClipboard)
Vue.use(plugins)
Vue.use(Toast)

new Vue({
  router,
  store,
  vuetify,
  render: function (h) { return h(App) }
}).$mount('#app')
