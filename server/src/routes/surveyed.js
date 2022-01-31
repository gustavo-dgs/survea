const express = require('express');
const router = express.Router();

const db = require('../database');


/******  SURVEYED  ********/

router.post('/', (req,res) =>{
    const {ID_Survey, ID_User}  = req.body;

    const query = `INSERT INTO Surveyed(Name, Email, ID_Survey, ID_User) 
                    VALUES ('','',?,?)`

    db.query(query, [ID_Survey, ID_User], (err,rows,fields) =>{
        if(!err){
            res.json(rows.insertId);
        }else{
            //res.send(err);
            console.log(err);
        }
    });
})

router.get('/', (req,res) =>{

    const {ID_Survey, ID_Surveyed} = req.query;
   
    const query = `SELECT s.*, sy.ID_Surveyed ,q.ID_Question, q.Question, q.Type, 
                        sa.Answer as Answer_surveyed, a.ID_Answer, a.Answer as Answer_survey
                    FROM survey s
                    INNER JOIN surveyed sy ON sy.ID_Survey = s.ID_Survey
                    LEFT JOIN question q ON q.ID_Survey = s.ID_Survey
                    LEFT JOIN surveyed_answer sa ON sa.ID_Question = q.ID_Question 
                        AND sa.ID_Surveyed = sy.ID_Surveyed
                    LEFT JOIN answer a ON a.ID_Question = q.ID_Question
                    WHERE s.ID_Survey = ?
                    AND sy.ID_Surveyed = ?`
    
    db.query( query ,[ID_Survey, ID_Surveyed], (err, rows, fields) =>{
        if(!err){
            res.json(rows);
        }else{
            console.log(err);
        }
    });
    
});

/******  SURVEYED ANSWER  ********/

router.post('/answer', (req,res) =>{
    const {Answer, ID_Question, ID_Survey, ID_User, ID_Surveyed}  = req.body;

    const query = `INSERT INTO surveyed_answer(Answer, ID_Question,
                    ID_Survey, ID_User, ID_Surveyed) 
                    VALUES (?,?,?,?,?)`

    db.query(query, [Answer, ID_Question, ID_Survey, ID_User, ID_Surveyed], 
        (err,rows,fields) =>{

        if(!err){
            res.send('Survey saved');
        }else{
            //res.send(err);
            console.log(err);
        }
    });
})

module.exports= router;