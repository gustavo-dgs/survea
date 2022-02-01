const express = require('express');
const router = express.Router();

const db = require('../database');


/******  RESULTS ********/

router.get('/:id', (req,res) =>{

    const {id} = req.params;
   
    const query = `SELECT q.ID_Question, q.Question, a.Answer, COUNT(s.Answer) as Total
                    FROM question q
                    LEFT JOIN answer a ON a.ID_Question = q.ID_Question
                        AND a.ID_Survey = q.ID_Survey
                    LEFT JOIN surveyed_answer s ON s.ID_Question = a.ID_Question 
                        AND s.ID_Survey = a.ID_Survey
                    WHERE q.ID_Survey = ?
                    AND s.Answer LIKE CONCAT("%", a.Answer, "%")
                    GROUP BY 1,2,3
                    
                    UNION ALL
                    
                    SELECT q.ID_Question, q.Question, s.Answer, COUNT(s.Answer) as Total
                    FROM question q
                    LEFT JOIN surveyed_answer s ON s.ID_Question = q.ID_Question 
                        AND s.ID_Survey = q.ID_Survey
                    WHERE q.ID_Survey = ?
                    AND q.Type <> 'checkbox'
                    AND q.Type <> 'select'
                    AND q.Type <> 'radio'
                    GROUP BY 1,2,3`
    
    db.query( query ,[id, id], (err, rows, fields) =>{
        if(!err){
            res.json(rows);
        }else{
            console.log(err);
        }
    });
    
});

router.get('/answers/:id', (req,res) =>{

    const {id} = req.params;
   
    const query = `SELECT s.ID_Surveyed, q.ID_Question, q.Question, s.Answer
                    FROM question q
                    LEFT JOIN surveyed_answer s ON s.ID_Question = q.ID_Question 
                        AND s.ID_Survey = q.ID_Survey
                    WHERE q.ID_Survey = ?
                    ORDER BY s.ID_Surveyed, q.ID_Question`
    
    db.query( query ,[id], (err, rows, fields) =>{
        if(!err){
            res.json(rows);
        }else{
            console.log(err);
        }
    });
    
});


module.exports = router;