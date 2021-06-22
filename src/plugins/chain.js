var Web3 = require('web3');
let web3 = new Web3(window.ethereum)
import inviteContract from './contract'

const chain = {
  getChainId(){
    return web3.eth.net.getId()
  },
  addChain(chainConfig){
    return ethereum.request({
      method: 'wallet_addEthereumChain',
      params: [chainConfig],
    })
  },
  requestPermission(){
    return ethereum.request({
      method: 'wallet_requestPermissions',
      params: [{ eth_accounts: {} }],
    })
  },
  requestAccount(){
    return ethereum.request({ method: 'eth_requestAccounts' });
  },
  inviteLower2Count(account){
    var myContract = new web3.eth.Contract(inviteContract.abi, inviteContract.address);
    return myContract.methods.inviteLower2Count(account).call()
  },
  inviteUpper1(account){
    var myContract = new web3.eth.Contract(inviteContract.abi, inviteContract.address);
    return myContract.methods.inviteUpper1(account).call()
  },
  inviteUpper2(account){
    var myContract = new web3.eth.Contract(inviteContract.abi, inviteContract.address);
    return myContract.methods.inviteUpper2(account).call()
  },
  inviteLower2(account){
    var myContract = new web3.eth.Contract(inviteContract.abi, inviteContract.address);
    return myContract.methods.inviteLower2(account).call()
  },
  acceptInvitation(from,invitor){
    var myContract = new web3.eth.Contract(inviteContract.abi, inviteContract.address);
    return myContract.methods.acceptInvitation(invitor).send({from})
  }
}

export default {
  install(Vue, options){
    Vue.prototype.$chain = chain
  }
}