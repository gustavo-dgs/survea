const express = require('express');
const router = express.Router();

const db = require('../database');

router.get('/survey', (req,res) =>{
    db.query('SELECT * FROM Survey', (err, rows, fields) =>{
        if(!err){
            res.json(rows);
        }else{
            console.log(err);
        }
    })
});

router.get('/survey/:id', (req,res) =>{
    const {id} = req.params;
    db.query('SELECT sur.*, ques.*, as.* FROM Survey as sur,Question as ques, Answer as ans WHERE sur.ID_Survey = ? AND sur.ID_Survey= ques.ID_Survey AND ',[id], (err, rows, fields) =>{
        if(!err){
            res.json(rows);
        }else{
            console.log(err);
        }
    })
});

router.post('/survey', (req,res) =>{
    const {} = req.body;
    db.query('INSERT INTO Survey() VALUES ',[], (err,rows,fields) =>{
        if(!err){

        }else{

        }
    })
})

router.put('/survey/:id', (req,res)=> {
    const {id} = req.params;
    const {} = req.body;
    db.query('UPDATE Survey SET ',[], (err,rows,fields) =>{
        if(!err){

        }else{

        }
    })
});


router.delete('/survey/:id', (req,res)=>{
    const {id} = req.params;
    db.query('DELETE FROM Survey WHERE ID_Survey = ?',[id], (err,rows,fields) =>{
        if (!err){
            res.json({status: 'Survey deleted'})
        }else{
            console.log(err)
        }
    });
});

module.exports= router;