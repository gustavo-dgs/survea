const express= require('express');
const session= require('express-session');
const morgan = require('morgan');
const path = require('path');
const cors = require('cors');
const history = require('connect-history-api-fallback');
require('dotenv').config();

//inicializaciones
const app= express();

//configuraciones
app.set('port', process.env.PORT || 4000);

//Middleware 
app.use(session({
    secret: 'secret_code',
    resave: true,
    cookie: { maxAge: 1000 * 60 * 60 * 24 },
    saveUninitialized: true
}));
app.use(morgan('dev'));
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended : true}));


//VARIABLES GLOBALES


//RUTAS
app.use('/api/survey', require('./routes/survey'));
app.use('/api', require('./routes/authentication'));
app.use('/api/surveyed', require('./routes/surveyed'));
app.use('/api/results', require('./routes/results'));

//Public
app.use(history());
app.use(express.static(path.join(__dirname, '/dist')));

//INICIAR EL SERVIDOR
app.listen(app.get('port'), () =>{
    console.log('Server on port', app.get('port'));
});