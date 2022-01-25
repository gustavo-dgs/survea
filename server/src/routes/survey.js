const express = require('express');
const router = express.Router();

const db = require('../database');

router.get('/', (req,res) =>{
    
    db.query('SELECT * FROM Survey', (err, rows, fields) =>{
        if(!err){
            res.json(rows);
        }else{
            console.log(err);
        }
    });
});

router.get('/:id', (req,res) =>{
    const {id} = req.params;
    const query = `SELECT s.*, q.ID_Question, q.Question, q.Type, a.ID_Answer, a.Answer
                    FROM question q, survey s, answer a
                    WHERE s.ID_Survey = ?
                    AND s.ID_User = 1
                    AND q.ID_Survey = s.ID_Survey
                    AND q.ID_User = s.ID_User
                    AND a.ID_User = q.ID_User
                    AND a.ID_Survey = q.ID_Survey
                    AND a.ID_Question = q.ID_Question
                    ORDER BY s.ID_User, s.ID_Survey, q.ID_Question, a.ID_Answer`
    
    db.query( query ,[id], (err, rows, fields) =>{
        if(!err){
            res.json(rows);
        }else{
            console.log(err);
        }
    });
    
});

router.post('/', (req,res) =>{
    const {ID_User} = req.body;

    db.query('INSERT INTO Survey(Title, StartDate, FinalDate, ID_User) VALUES (?,?,?,?)',
        ['untitle', new Date, new Date, ID_User], (err,rows,fields) =>{
        if(!err){
            res.json(rows.insertId);
                
        }else{
            //res.send(err);
            console.log(err);
        }
    });
})

router.put('/:id', (req,res)=> {
    const {id} = req.params;
    const {Title, Description} = req.body;
    const query = 'UPDATE Survey SET Title = ?, Description = ? WHERE ID_Survey = ?'
    db.query( query ,[Title, Description, id], (err,rows,fields) =>{
        if(!err){
            res.send('All save');
        }else{
            console.log(err);
            res.send('Error updating');
        }
    });

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