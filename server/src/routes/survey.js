const express = require('express');
const router = express.Router();

const db = require('../database');

/******   SURVEY  ********/

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
                    FROM survey s
                    LEFT JOIN question q ON q.ID_Survey = s.ID_Survey
                    LEFT JOIN answer a ON a.ID_Question = q.ID_Question
                    WHERE s.ID_Survey = 25
                    AND s.ID_User = 1`
    
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


router.delete('/:id', (req,res)=>{
    const {id} = req.params;
    db.query('DELETE FROM Survey WHERE ID_Survey = ?',[id], (err,rows,fields) =>{
        if (!err){
            res.json({status: 'Survey deleted'})
        }else{
            console.log(err)
        }
    });
});

/******   QUESTION ********/

router.post('/question', (req,res) =>{
    const {ID_Question, Type, Question, ID_Survey, ID_User}  = req.body;

    const query = `INSERT INTO Question(ID_Question, Type, Question, 
                    ID_Survey, ID_User) 
                    VALUES (?,?,?,?,?)`

    db.query(query,
        [ID_Question, Type, Question, ID_Survey, ID_User], (err,rows,fields) =>{
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
    const {Question, Type, ID_Survey, ID_User} = req.body;
    const query = `UPDATE Question SET Question = ?, Type = ?
                    WHERE ID_Question = ?
                    AND ID_Survey = ?
                    AND ID_USer = ?`
    db.query( query ,[Question, Type, id, ID_Survey, ID_User], (err,rows,fields) =>{
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
    const {ID_Survey, ID_User} = req.body;
    const query = `DELETE FROM Answer
                    WHERE ID_Question = ?
                    AND ID_Survey = ?
                    AND ID_User = ?;
                    
                    DELETE FROM Question
                    WHERE ID_Question = ?
                    AND ID_Survey = ?
                    AND ID_User = ?`

    db.query( query ,[id, ID_Survey, ID_User, id, ID_Survey, ID_User], (err,rows,fields) =>{
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
    const {ID_Answer, Answer, ID_Question, ID_Survey,ID_User}  = req.body;

    console.log('ID_Answer', ID_Answer);

    const query = `INSERT INTO Answer(ID_Answer, Answer, ID_Question, ID_Survey, ID_User) 
                    VALUES (?,?,?,?,?)`

    db.query(query,
        [ID_Answer, Answer, ID_Question, ID_Survey,ID_User], (err,rows,fields) =>{
        if(!err){
            res.send('Answer Added');  
        }else{
            //res.send(err);
            console.log(err);
        }
    });
})

router.put('/answer/:id', (req,res)=> {
    //const {ID_Answer, ID_Question, ID_Survey, ID_User} = req.params;
    const {id} = req.params;
    const {Answer, ID_Question, ID_Survey, ID_User} = req.body;
    const query = `UPDATE Answer SET Answer = ?
                    WHERE ID_Answer = ?
                    AND ID_Question = ?
                    AND ID_Survey = ?
                    AND ID_User = ?`
    db.query( query ,[Answer, id, ID_Question, ID_Survey, ID_User], (err,rows,fields) =>{
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
    const {ID_Question, ID_Survey, ID_User} = req.body;
    const query = `DELETE FROM Answer
                    WHERE ID_Answer = ?
                    AND ID_Question = ?
                    AND ID_Survey = ?
                    AND ID_User = ?`
    db.query( query ,[id, ID_Question, ID_Survey, ID_User], (err,rows,fields) =>{
        if(!err){
            res.send('Answer delete');
        }else{
            console.log(err);
            res.send('Error updating');
        }
    });

});

module.exports= router;