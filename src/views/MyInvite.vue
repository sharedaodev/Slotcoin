<template>
  <v-container style="">
    <v-col cols="12" style="">
        <v-card elevation="0" class="pa-1">
        <div class="py-0 px-0" >
          <span class="d-block text-body-1">Reward by Invitation</span>
          <span class="d-block text-body-1">Invite a friend to redeem a $Slot and you will receive an additional invitation bonus.</span>
          <span class="d-block text-body-1">Level 1 Invitation award bonus of 1.2%.</span>
          <span class="d-block text-body-1">A secondary invitation award bonus of 0.8%.</span>
          <span class="d-block text-body-1">The above Invitation Bonus is given by a 2% commission from the seller's 17% transaction fee.</span>
          <span class="d-block text-body-1">Invite your friends now to start your SlotCoin journey, the more you invite, the more you are rewarded.</span>
        </div>
      </v-card>
      </v-col>
      <v-col cols="12">
        <v-card elevation="0" v-if="btn" class="pa-0">
          <span class="text-h6 d-block">Invitation link</span>
            <div  cols="10"
              class="px-2 py-1 rounded mt-1 d-flex flex-row align-center justify-center"
                style="background:#edeaf3;">
              <v-btn @click="copyLink" color="#760FEB" style="color: #fff;" depressed small>COPY</v-btn>
              <span  class="invitelinkaddress  px-2 py-2"  style="flex:1; overflow:hidden;">{{inviteLink}}</span>
            </div>
            
        </v-card>
         <v-card elevation="0" v-if="!btn" class="pa-0 ">
          <span class="text-h6 d-block">Invitation link</span>
            <div  cols="10"
              class="px-2 py-1 rounded mt-1 "
                style="background:#edeaf3;">
              <span  class="invitelinkaddress"  style="flex:1; overflow:hidden;">{{inviteLink}}</span>
            </div>
            <v-btn class=" my-2" @click="copyLink" color="#760FEB" style="color: #fff;width:100%" depressed small>COPY</v-btn>
        </v-card>
      </v-col>
      <v-col cols="12">
        <v-card elevation="0" class="pa-1">    
          <span class="text-h6 d-block">Cumulative Inviting Benefits</span>
          <v-row class="mt-0">
            <v-col cols="6">
              <div style="background:#edeaf3;" class="rounded-xl pa-6">
                <span class="d-block font-weight-bold">Level 1 Friends</span>
                <span class="d-block mt-3">{{level1Count}} persons</span>
              </div>
            </v-col>
            <v-col cols="6">
              <div style="background:#edeaf3;" class="rounded-xl pa-6">
                <span class="d-block font-weight-bold">Level 2 Friends</span>
                <span class="d-block mt-3">{{level2Count}} persons</span>
              </div>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
      <v-col cols="12">
        <v-card elevation="0" class="pa-2">
          <span class="text-h6 d-block">My Level 1 Friends Invitation</span>
          <div class="mt-4">
            <span 
              class="d-block text-lowercase" 
              v-for="(address,n) in level1Invitations" 
              :key="n">
              {{address}}
            </span>
          </div>
        </v-card>
      </v-col>
      <v-col cols="12">
        <v-card elevation="0" class="pa-2">
          <span class="text-h6 d-block">My Level 2 Friends Invitation</span>
          <div class="mt-4">
            <span 
              class="d-block text-lowercase" 
              v-for="(address,n) in level2Invitations" 
              :key="n">
              {{address}}
            </span>
          </div>
          
        </v-card>
      </v-col>

  </v-container>
</template>

<script>
import appConfig from '../config/appConfig'


export default {
  data(){
    return {
      level1Count: 0,
      level2Count: 0,
      level1Invitations: [],
      level2Invitations: [],
      invitations: [
        '0xc4D1Ae24FbDBA2eF9969b0a1e452AaDBbBDe8DB8',
        '0xc4D1Ae24FbDBA2eF9969b0a1e452AaDBbBDe8DB8',
        '0xc4D1Ae24FbDBA2eF9969b0a1e452AaDBbBDe8DB8',
        '0xc4D1Ae24FbDBA2eF9969b0a1e452AaDBbBDe8DB8',
      ],
      screenWidth: document.body.clientWidth,
      btn:false,
    }
  },
  computed:{
    inviteLink(){
      return appConfig.domain + 'invite/'+this.$store.state.account
    }
  },
  mounted(){
     const that = this
    if (typeof window.ethereum == 'undefined') {
      alert("MetaMask is not installed!")
      return
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
    this.$chain.requestAccount().then(accounts => {
      const account = accounts[0];
      this.$chain.inviteLower2Count(account)
        .then(resp => {
          console.log(resp)
          this.level1Count = resp[0]
          this.level2Count = resp[1]
        })
      this.$chain.inviteLower2(account)
        .then(resp => {
          console.log(resp)
          this.level1Invitations = resp[0]
          this.level2Invitations = resp[1]
        })
    })

    
  },
  methods: {
    copyLink(){
      this.$copyText(this.inviteLink);
      this.$toast('Inviation link has been copy');
    },
  }
}
</script>
<style scoped>
  .cs{
    text-align: center;
    display: none;
  
  }
 
</style>