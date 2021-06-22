
const filters = {
  addressClip(address){
    if(!address){
      return address
    }
    var value = address.toLowerCase()
    if(!value.startsWith('0x')){
      value = '0x'+value
    }
    return value.substr(0,10)+'...'+value.substr(-8)
  },
}

export default {
  install(Vue, options){
    Object.keys(filters).forEach(key => {
      Vue.filter(key, filters[key])
    })
  }
}