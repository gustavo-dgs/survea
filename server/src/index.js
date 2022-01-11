const express= require('express');
const morgan = require('morgan');
//inicializaciones
const app= express();

//configuraciones
app.set('port', process.env.PORT || 4000);


//Middlewares
app.use(morgan('dev'));

//VARIABLES GLOBALES

//RUTAS
app.use(require('./routes/index'));

//Public

//INICIAR EL SERVIDOR
app.listen(app.get('port'), () =>{
    console.log('Servidor en puerto 4000');
});