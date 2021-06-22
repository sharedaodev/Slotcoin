<template>
  <v-app style="">
    <v-app-bar app class="navigation" dark>
      <div class="d-flex align-center">
        <v-img :to="{name:'MyInvite'}" class="shrink mr-2" contain src="./assets/logo.png" transition="scale-transition" 
          width="40" @click="navIndex" />
        <span class="mr-2 text-lowercase">slotcoin</span>
      </div>
      <v-spacer></v-spacer>
      <v-btn @click="connectWallet" v-if="account" text>
        <span class="mr-2 text-lowercase">{{account | addressClip}}</span>
      </v-btn>
      <v-btn v-else  @click="connectWallet" text>
        <span class="mr-2">wallet</span>
      </v-btn>
    </v-app-bar>
    <v-main>
      <router-view />
      
      <v-dialog v-model="waitingDialog" persistent max-width="400px">
        <v-card  color="#2b095e" style="color:#fff;position:relative;padding:10px;position:relative;">
          <div class="pa-8 d-flex flex-column align-center" style="border:4px solid #a30ef0;">
            <v-progress-circular indeterminate :size="100" color="primary"></v-progress-circular>
            <span class="mt-4 font-weight-bold " style="color:#a30ef0;font-size:20px;">Please change to {{metamaskConfig.network}}</span>
          </div>
        </v-card>
      </v-dialog>

    </v-main>
  </v-app>
</template>

<script>
import chainConfig from './config/chainConfig'
var Web3 = require('web3');

export default {
  name: 'App',

  data: () => ({
    waitingDialog: false,
    metamaskConfig: chainConfig,
     
  }),
  computed:{
    account(){
      return this.$store.state.account
    }
  },
  mounted(){
        
    if (typeof window.ethereum == 'undefined') {
      alert("Wallet EXTENSION (eg:MetaMask) is not installed!")
      return
    }
   
    this.$chain.requestAccount().then(accounts => {
      const account = accounts[0];
      this.$store.dispatch("walletConnect", {account});
    })

    ethereum.on('chainChanged', (chainId) => {
      console.log('chainChanged')
      window.location.reload();
    });

    ethereum.on('accountsChanged', accounts => {
      console.log('accountsChanged')
      window.location.reload();
    });

    this.checkNetwork()
  },
  methods:{
    navIndex(){
      window.location.href='https://invite.slotcoin.finance/';
    },
    checkNetwork(){
      this.$chain.getChainId()
        .then(chainId => {
          if(chainId!=chainConfig.chainId){
            this.waitingDialog = true
            this.$chain.addChain({
              chainId: Web3.utils.toHex(chainConfig.chainId),
              rpcUrls: [chainConfig.rpc],
              chainName: chainConfig.network,
              nativeCurrency: { 
                name: chainConfig.symbol, 
                decimals: chainConfig.decimal, 
                symbol: chainConfig.symbol },
              blockExplorerUrls: [chainConfig.explorer],
            })
          }else{
            this.waitingDialog = false
          }
        })
    },
    connectWallet(){
      if (typeof window.ethereum == 'undefined') {
        alert("Wallet EXTENSION (eg:MetaMask) is not installed!")
        return
      }
      this.$chain.requestPermission()
        .then(resp => {
          console.log(resp)
        })
    }
  }
};
</script>
<style scoped>
.navigation{
    background-image: linear-gradient(to right, #760FEB , #461286);
}
/* .v-sheet.v-card:not(.v-sheet--outlined) {
    box-shadow: 0px 3px 1px -2px rgb(0 0 0 / 20%), 0px 2px 2px 0px rgb(0 0 0 / 14%), 0px 1px 5px 0px rgb(0 0 0 / 12%);
}
.v-sheet:not(.v-sheet--outlined) {
    box-shadow: 0px 0px 0px 0px rgb(0 0 0 / 20%), 0px 0px 0px 0px rgb(0 0 0 / 14%), 0px 0px 0px 0px rgb(0 0 0 / 12%);
} */
v-card{
    box-shadow:none !important
  }
</style>
