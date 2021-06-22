<template>
  <v-container>
    <v-card elevation="0" style="" cols="12"
      class="mx-auto mt-6">
      <v-card-title class=" text-h4">Invitation</v-card-title>
      <v-card-text class="text-body-1">
        Do you accept the invitation from : 
        <span class="font-weight-bold">{{invitor}}</span>
      </v-card-text>
      <v-card-actions v-if="btn">
        <v-btn v-if="!isSelf && !isInvited" @click="acceptInvitation" depressed color="primary">ACCEPT</v-btn>
        <!-- <v-btn @click="navigateToMDX" depressed color="primary">GO MDX</v-btn> -->
      </v-card-actions>
       <v-card-actions v-if="!btn">
        <v-btn v-if="!isSelf && !isInvited" @click="acceptInvitation" style="width:50%"  depressed color="primary">ACCEPT</v-btn>
        <!-- <v-btn @click="navigateToMDX"  style="width:50%"  depressed color="primary">GO MDX</v-btn> -->
      </v-card-actions>
    </v-card>

    <v-dialog
      v-model="waitingDialog"
      persistent
      max-width="400px">
      <v-card color="#2b095e" style="color:#fff;position:relative;padding:10px;position:relative;">
        <div class="pa-8 d-flex flex-column align-center" style="border:4px solid #a30ef0;">
          <v-progress-circular
            indeterminate
            :size="100"
            color="primary"
          ></v-progress-circular>
          <span class="mt-4 font-weight-bold" style="color:#a30ef0;font-size:20px;">Please open your metamask</span>
        </div>
      </v-card>
    </v-dialog>

  </v-container>
</template>

<script>
export default {
  data(){
    return {
      waitingDialog: false,
      invitor: this.$route.params.address,
      isInvited: true,
       screenWidth: document.body.clientWidth,
      btn:false,
    }
  },
  computed:{
    isSelf(){
      return this.$route.params.address == this.$store.state.account
    }
  },
  mounted(){
    const that = this
    if (!this.$store.getters.isConnected) {
      this.waitingDialog = true
      this.$chain.requestPermission().then(resp => {
        console.log(resp)
      })
    }else{
      this.$chain.requestAccount().then(accounts => {
        const account = accounts[0];
        this.queryInvitor(account)
      })
    }
     window.addEventListener('resize',function(){
        that.screenWidth = document.body.offsetWidth;
        console.log( that.screenWidth)
        if(that.screenWidth>500){
          that.btn=true
        }else{
          that.btn=false
        }
        console.log(that.btn)
    })
  },
  methods: {
    queryInvitor(account){
      this.$chain.inviteUpper1(account)
        .then(resp => {
          console.log(resp)
          this.isInvited = resp!='0x0000000000000000000000000000000000000000'
        })
    },
    acceptInvitation(){
      if (!this.$store.getters.isConnected) {
        this.waitingDialog = true
        this.$chain.requestPermission().then(resp => {
          console.log(resp)
        })
      }else{
        this.$chain.acceptInvitation(this.$store.state.account,this.$route.params.address)
          .then(resp => {
            console.log(resp)
            if (resp) {
              this.$router.push({name: 'MyInvite'})
            }
          })
      }
    },
    navigateToMDX(){
      window.location.href='https://ht.mdex.com/#/swap?lang=en';
    }
  }
}
</script>