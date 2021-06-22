import filters from './filters'
import chain from './chain'

const plugins = [
  filters,
  chain,
]

export default {
  install(Vue, options){
    plugins.forEach(plugin => {
      Vue.use(plugin);
    });
  }
}