<template>
    
    <section class="log-sign">

        <div class="log-sign__color"></div>
        <div class="log-sign__color"></div>
        <div class="log-sign__color"></div>

        <div class="box-back">
            <div class="log-sing__box__square" style="--i:0;"></div>
            <div class="log-sing__box__square" style="--i:1;"></div>
            <div class="log-sing__box__square" style="--i:2;"></div>
            <div class="log-sing__box__square" style="--i:3;"></div>
            <div class="log-sing__box__square" style="--i:4;"></div>

            <div class="log-sing__box">
            
                <div class="log-sign__box__header">
                    <h2 @click="containerState=true" >Login</h2>
                    <h2 @click="containerState=false">Sign Up</h2>
                </div>

                <div class="log-sign__box__container"
                    :style ="{ 'justify-content': switchForm }" 
                >
                    <form class="log-sign__box__container__login"
                        v-if="containerState"
                        @submit.prevent="loginUser"
                    >
                        <h3 class="log-sing__label">Email</h3>
                        <input class="log-sing__input" type="email" placeholder="Email">
                        <h3 class="log-sing__label">Password</h3>
                        <input class="log-sing__input" type="password" placeholder="Password">
                        <input class="log-sing__input" type="submit" value="Login">
                        <p class="log-sign__box__container__login__forget">He olvidado la Password <a href="#">Click Aqui</a> </p>
                    </form>

                    <form  class="log-sign__box__container__register"
                        v-else
                        @submit.prevent="registerUser"
                    >
                        <h3 class="log-sing__label">Name</h3>
                        <input class="log-sing__input" type="text" placeholder="Name">
                        <h3 class="log-sing__label">Last Name</h3>
                        <input class="log-sing__input" type="text" placeholder="Last Name">
                        <h3 class="log-sing__label">Email</h3>
                        <input class="log-sing__input" type="email" placeholder="Email">
                        <h3 class="log-sing__label">Password</h3>
                        <input class="log-sing__input" type="password" placeholder="Password">
                        <h3 class="log-sing__label">Chack your Password</h3>
                        <input class="log-sing__input" type="password" placeholder="Chack your Password">
                        <input class="log-sing__input" type="submit" value="Register">
                    </form>
                </div>
            </div>

        </div>

        
    </section>
    
</template>

<script>
export default {
    data() {
        return {
            containerState:true
        }
    },
    
    methods: {
        registerUser(event) {
            const arr = Array.from(event.target.elements);
           
            if (arr.some(x => x.value === '')) {
                alert('Error: the form is not complete');
                return;
            }

            if (arr[3].value !== arr[4].value) {
                alert('Error: the passwords do not match');
                return;
            }

            const user = {
                name: arr[0].value,
                lastname: arr[1].value, 
                email: arr[2].value, 
                password: arr[3].value
            }

            this.axios.post('signup', user)
                .then(res => console.log(res))
                .catch(err => console.log(err));
        },

        loginUser(event) {
            const arr = Array.from(event.target.elements);
           
            if (arr.some(x => x.value === '')) {
                alert('Error: the form is not complete');
                return;
            }

            this.axios.get(`login`, {
                params: {
                    email: arr[0].value, 
                    password: arr[1].value
                }
            })
                .then(res => {
                    if (res.data.code === 200) {
                        this.$router.push(`/user/${res.data.User.ID_User}`);
                    } else {
                        alert(res.data.msg);
                    }
                })
                .catch(err => console.log(err));
        }
    }
}
</script>

<style>

.log-sign{
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient( to bottom, #f1f4f9, #dff1ff );
    height: 100vh;
}
.log-sign__color{
    position: absolute;
    filter: blur(150px);
}
.log-sign__color:nth-child(1){
    top: -350px;
    width: 600px;
    height: 600px;
    background: #ff359b;
}
.log-sign__color:nth-child(2){
    bottom: 0;
    left: 100px;
    width: 500px;
    height: 500px;
    background: #fffd87;
}
.log-sign__color:nth-child(3){
    bottom: 50px;
    right: 100px;
    width: 300px;
    height: 300px;
    background: #00d2ff;
}
.box-back{
    position: relative;
}
.log-sing__box__square{
    position: absolute;
    backdrop-filter: blur(5px);
    box-shadow: 0 25px 45px rgba(0,0,0,0.1);
    border: 1px solid rgba(255,255,255,0.5);
    border-right: 1px solid rgba(255,255,255,0.2);
    border-bottom: 1px solid rgba(255,255,255,0.2);
    background: rgba(255,255,255,0.1);
    border-radius: 10px;
    animation: animate 10s linear infinite;
    animation-delay: calc(-1s * var(--i));
}
@keyframes animate{
    0%,100%{
        transform: translateY(-40px);
    }
    50%{
        transform: translateY(40px);
    }
}
.log-sing__box__square:nth-child(1){
    top: -50px;
    right: -60px;
    width: 100px;
    height: 100px;
}
.log-sing__box__square:nth-child(2){
    top: 150px;
    left: -100px;
    width: 120px;
    height: 120px;
    z-index: 2;
}
.log-sing__box__square:nth-child(3){
    bottom: -50px;
    right: -60px;
    width: 80px;
    height: 80px;
    z-index: 2;
}
.log-sing__box__square:nth-child(4){
    bottom: -80px;
    left: 100px;
    width: 50px;
    height: 50px;
}
.log-sing__box__square:nth-child(5){
    top: -80px;
    left: 140px;
    width: 60px;
    height: 60px;
}
.log-sing__box{
    position: relative;
    width: 400px;
    background: rgba(150, 150, 150, 0.247);
    border-radius: 10px;
    display: flex;
    justify-content: center;
    flex-direction: column;
    align-items: center;
    backdrop-filter: blur(5px);
    box-shadow: 0 25px 45px rgba(0,0,0,0.1);
    border: 1px solid rgba(255,255,255,0.5);
    border-right: 1px solid rgba(255,255,255,0.2);
    border-bottom: 1px solid rgba(255,255,255,0.2);
    transition: 0.4s;
    /* overflow-x: auto; */

}

.log-sing__box > * {
    margin: 15px 0;
}

.log-sign__box__header{
    display: flex;
    align-items: center;
    width: 100%;
}
.log-sign__box__header h2{
    width: 50%;
    padding-top: 15px;
    padding-bottom: 15px;
    font-size: 20px;
    text-align: center;
    color: #fff;
    cursor: pointer;
}
.log-sign__box__container{
    display: flex;
    justify-content: flex-start;
    align-items: center;
    width: 400px;
    overflow-x: hidden;
    overflow-y: hidden;
    transition: 0.4s;
}
.log-sign__box__container form{
    width: 400px;
    height: auto;
    padding: 5px 9%;
    transition: 0.4s;
}
.log-sign__box__container form h3{
    position: relative;
    color: #fff;
    font-size: 15px;
    font-weight: 600;
    letter-spacing: 1px;
    margin-bottom: 5px;
}
.log-sign__box__container form input{
    width: 300px;
    margin-bottom: 20px;
    background: rgba(255,255,255,0.2);
    border: none;
    outline: none;
    padding: 10px 20px;
    border-radius: 35px;
    border: 1px solid rgba(255,255,255,0.5);
    border-right: rgba(255,255,255,0.2);
    border-bottom: rgba(255,255,255,0.2);
    font-size: 10px;
    letter-spacing: 1px;
    color: #fff;
    box-shadow: 0 5px 15px rgba(0,0,0,0.05);
}
.log-sign__box__container form input::placeholder{
    color: #fff;
}
.log-sign__box__container form input[type="submit"]{
    background: #fff;
    color: #666;
    max-width: 100px;
    cursor: pointer;
    margin-bottom: 5px;
    font-weight: 600;
}
.log-sign__box__container__login__forget{
    margin-top: 5px;
    color: #fff;
}
.log-sign__box__container__login__forget a{
    color: #fff;
    font-weight: 600;
}
</style>