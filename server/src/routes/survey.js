const express = require('express');
const router = express.Router();

const db = require('../database');

/******   SURVEY  ********/

router.get('/user/:id', (req,res) =>{

    const {id} = req.params;

    const query = `SELECT * FROM Survey
                    WHERE ID_User = ?`

    db.query(query, [id], (err, rows, fields) =>{
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
                    FROM Survey s
                    LEFT JOIN Question q ON q.ID_Survey = s.ID_Survey
                    LEFT JOIN Answer a ON a.ID_Question = q.ID_Question
                        AND a.ID_Survey = q.ID_Survey
                    WHERE s.ID_Survey = ?`
    
    db.query( query ,[id], (err, rows, fields) =>{
        if(!err){
            res.json(rows);
        }else{
            console.log(err);
        }
    });
    
});

router.post('/', (req,res) =>{
    const {Title, StartDate, FinalDate, ID_User} = req.body;

    db.query('INSERT INTO Survey(Title, StartDate, FinalDate, ID_User) VALUES (?,?,?,?)',
        [Title, StartDate, FinalDate, ID_User], (err,rows,fields) =>{
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

router.delete('/:id', (req,res)=> {
    const {id} = req.params;
    const query = `
                    DELETE FROM Surveyed_Answer
                    WHERE ID_Survey = ?;

                    DELETE FROM Surveyed
                    WHERE ID_Survey = ?;

                    DELETE FROM Answer
                    WHERE ID_Survey = ?;
                    
                    DELETE FROM Question
                    WHERE ID_Survey = ?;
                    
                    DELETE FROM Survey
                    WHERE ID_Survey = ?`

    db.query( query ,[id, id, id, id, id], (err,rows,fields) =>{
        if(!err){
            res.send('Survey deleted');
        }else{
            console.log(err);
            res.send('Error deleting');
        }
    });

});

/******   QUESTION ********/

router.post('/question', (req,res) =>{
    const {ID_Question, Type, Question, ID_Survey}  = req.body;

    const query = `INSERT INTO Question(ID_Question, Type, Question, 
                    ID_Survey) 
                    VALUES (?,?,?,?)`

    db.query(query,
        [ID_Question, Type, Question, ID_Survey], (err,rows,fields) =>{
        if(!err){
            res.send('Question Added');  
        }else{
            //res.send(err);
            console.log(err);
        }
    });
})

router.put('/question/:id', (req,res)=> {
    
    const {id} = req.params;
    const {Question, Type, ID_Survey} = req.body;
    const query = `UPDATE Question SET Question = ?, Type = ?
                    WHERE ID_Question = ?
                    AND ID_Survey = ?`
    db.query( query ,[Question, Type, id, ID_Survey], (err,rows,fields) =>{
        if(!err){
            res.send('Question update');
        }else{
            console.log(err);
            res.send('Error updating');
        }
    });

});

router.delete('/question/:id', (req,res)=> {
    const {id} = req.params;
    const {ID_Survey} = req.body;
    const query = `DELETE FROM Answer
                    WHERE ID_Question = ?
                    AND ID_Survey = ?;
                    
                    DELETE FROM Question
                    WHERE ID_Question = ?
                    AND ID_Survey = ?`

    db.query( query ,[id, ID_Survey, id, ID_Survey], (err,rows,fields) =>{
        if(!err){
            res.send('Question deleted');
        }else{
            console.log(err);
            res.send('Error deleting');
        }
    });

});

/******   ANSWER ********/

router.post('/answer', (req,res) =>{
    const {ID_Answer, Answer, ID_Question, ID_Survey}  = req.body;

    const query = `INSERT INTO Answer(ID_Answer, Answer, ID_Question, ID_Survey) 
                    VALUES (?,?,?,?)`

    db.query(query,
        [ID_Answer, Answer, ID_Question, ID_Survey], (err,rows,fields) =>{
        if(!err){
            res.send('Answer Added');  
        }else{
            //res.send(err);
            console.log(err);
        }
    });
})

router.put('/answer/:id', (req,res)=> {
    
    const {id} = req.params;
    const {Answer, ID_Question, ID_Survey} = req.body;
    const query = `UPDATE Answer SET Answer = ?
                    WHERE ID_Answer = ?
                    AND ID_Question = ?
                    AND ID_Survey = ?`
    db.query( query ,[Answer, id, ID_Question, ID_Survey], (err,rows,fields) =>{
        if(!err){
            res.send('Answer save');
        }else{
            console.log(err);
            res.send('Error updating');
        }
    });

});

router.delete('/answer/:id', (req,res)=> {
    console.log(req.body);
    const {id} = req.params;
    const {ID_Question, ID_Survey} = req.body;
    const query = `DELETE FROM Answer
                    WHERE ID_Answer = ?
                    AND ID_Question = ?
                    AND ID_Survey = ?`
    db.query( query ,[id, ID_Question, ID_Survey], (err,rows,fields) =>{
        if(!err){
            res.send('Answer delete');
        }else{
            console.log(err);
            res.send('Error updating');
        }
    });

});

module.exports= router;