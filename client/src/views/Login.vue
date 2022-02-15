<template>
    
    <section class="log-sign">

        <div class="log-sign__color"></div>
        <div class="log-sign__color"></div>
        <div class="log-sign__color"></div>

        <div class="log-sing__box__square a" ></div>
        <div class="log-sing__box__square b" ></div>
        <div class="log-sing__box__square c" ></div>
        <div class="log-sing__box__square d" ></div>
        <div class="log-sing__box__square e" ></div>

        <div class="box-back">

            <div class="log-sing__box"
                ref="logSing__box"
            >
            
                <div class="log-sign__box__header">
                    <h2 @click="switchForm" >Login</h2>
                    <h2 @click="switchForm">Sign Up</h2>
                </div>

                <div class="log-sign__box__container"
                    :style ="{ 'justify-content': switchForm }" 
                >
                    <form class="log-sign__box__container__login"
                        v-if="containerState"
                        @submit.prevent="loginUser"
                    >
                        <h3 class="log-sing__label">Email</h3>
                        <input class="log-sing__input" type="email" >
                        <h3 class="log-sing__label">Password</h3>
                        <input class="log-sing__input" type="password" >
                        <input class="log-sing__input" type="submit" value="Login">
                        <p class="log-sign__box__container__login__forget">He olvidado la Password <a href="#">Click Aqui</a> </p>
                    </form>

                    <form  class="log-sign__box__container__register"
                        v-else
                        @submit.prevent="registerUser"
                    >
                        <h3 class="log-sing__label">Name</h3>
                        <input class="log-sing__input" type="text" >
                        <h3 class="log-sing__label">Last Name</h3>
                        <input class="log-sing__input" type="text" >
                        <h3 class="log-sing__label">Email</h3>
                        <input class="log-sing__input" type="email" >
                        <h3 class="log-sing__label">Password</h3>
                        <input class="log-sing__input" type="password" >
                        <h3 class="log-sing__label">Chack your Password</h3>
                        <input class="log-sing__input" type="password" >
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
        switchForm() {
            if (this.containerState) {
                this.$refs.logSing__box.style.height = '600px';
            } else {
                this.$refs.logSing__box.style.height = '400px';
            }

            this.containerState = !this.containerState;
        },
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
                .then(res => {
                    if (res.data.code === 200) {
                        this.$router.push(`/user/${res.data.User.ID_User}`);
                    } else {
                        alert(res.data.msg);
                    }
                })
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
    flex-direction: column;
    justify-content: center;
    align-items: center;
    background: linear-gradient( to bottom, #f1f4f9, #dff1ff );
    height: 100vh;
    overflow: hidden;
}
.log-sign__color{
    position: relative;
    filter: blur(150px);
    flex-shrink: 0;
}

.log-sign__color:nth-child(1){
    top: 45vh;
    width: 600px; 
    height: 600px;
    background: #ff359b;
    z-index: 5;
}
.log-sign__color:nth-child(2){
    left: -20vw;
    top: 300px;
    width: 500px;
    height: 500px;
    background: #fffd87;
    z-index: 10;
}
.log-sign__color:nth-child(3){
    top: -280px;
    left: 25vw;
    width: 300px;
    height: 300px;
    background: #00d2ff;
    z-index: 15;
}

.log-sing__box__square{
    position: relative;
    flex-shrink: 0;
    backdrop-filter: blur(5px);
    box-shadow: 0 25px 45px rgba(0,0,0,0.1);
    border: 1px solid rgba(255,255,255,0.5);
    border-right: 1px solid rgba(255,255,255,0.2);
    border-bottom: 1px solid rgba(255,255,255,0.2);
    background: rgba(255,255,255,0.1);
    border-radius: 10px;
    animation: animate 10s linear infinite;
    animation-delay: calc(-1s * var(--i));
    z-index: 30;
    top: -700px;
    
}

.a{
    left: 200px;
    width: 100px;
    height: 100px;
    z-index: 20;
}
.b{
    top: -650px;
    left: -240px;
    width: 120px;
    height: 120px;
    z-index: 85;
}
.c{
    left: 200px;
    top: -550px;
    width: 80px;
    height: 80px;
    z-index: 85;
}
.d{
    top: -590px;
    left: -100px;
    width: 50px;
    height: 50px;
    z-index: 20;
}
.e{
    top: -1130px;
    width: 60px;
    height: 60px;
    z-index: 20;
}

@keyframes animate{
    0%,100%{
        transform: translateY(-40px);
    }
    50%{
        transform: translateY(40px);
    }
}

.box-back{
    position: absolute;
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    z-index: 50;
    overflow-y: auto;
}

.log-sing__box{
    min-width: 320px;
    max-width: 400px;
    flex-grow: 1;
    margin: 20px;
    height: 400px;
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
    transition: height 1.5s;

}

.log-sign__box__header{
    display: flex;
    align-items: center;
    width: 100%;
    height: 60px;
}
.log-sign__box__header h2{
    width: 50%;
    font-size: 20px;
    text-align: center;
    color: #fff;
    cursor: pointer;
}
.log-sign__box__container{
    display: flex;
    justify-content: flex-start;
    align-items: center;
    width: 100%;
    overflow-x: hidden;
    overflow-y: hidden;
    transition: 0.4s;
}
.log-sign__box__container form{
    width: 100%;
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
    width: 100%;
    margin-bottom: 20px;
    background: rgba(255,255,255,0.2);
    border: none;
    outline: none;
    padding: 10px 20px;
    border-radius: 35px;
    border: 1px solid rgba(255,255,255,0.5);
    border-right: rgba(255,255,255,0.2);
    border-bottom: rgba(255,255,255,0.2);
    font-size: 15px;
    letter-spacing: 1px;
    color: #fff;
    box-shadow: 0 5px 15px rgba(0,0,0,0.05);
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