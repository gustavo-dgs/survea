const express= require('express');
const morgan = require('morgan');
const path = require('path');
const cors = require('cors');
const history = require('connect-history-api-fallback');

//inicializaciones
const app= express();

//configuraciones
app.set('port', process.env.PORT || 4000);


//Middlewares
app.use(morgan('dev'));
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended : true}));

//VARIABLES GLOBALES

//RUTAS
app.use('/api', require('./routes/index'));

//Public
app.use(history());
app.use(express.static(path.join(__dirname, '/public')));

//INICIAR EL SERVIDOR
app.listen(app.get('port'), () =>{
    console.log('Server on port', app.get('port'));
});