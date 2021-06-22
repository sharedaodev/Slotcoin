import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

function isEmpty(obj){
  if(typeof obj == "undefined" || obj == null || obj == ""){
      return true;
  }else{
      return false;
  }
}

export default new Vuex.Store({
  state: {
    account: localStorage.getItem('account')||'',
  },
  getters: {
    isConnected: state => !isEmpty(state.account),
  },
  mutations: {
    userStatus(state, payload){
      localStorage.setItem('account',payload.account||'')
      state.account = payload.account
    }
  },
  actions: {
    walletConnect({commit}, payload){
      commit('userStatus', payload)
    }
  },
  modules: {
  }
})
