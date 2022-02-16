const express = require('express');
const router = express.Router();
const xl = require('excel4node');
const path = require('path');

const db = require('../database');


/******  RESULTS ********/

router.get('/:id', (req,res) =>{

    const {id} = req.params;
   
    const query = `SELECT q.ID_Question, q.Question, a.Answer, COUNT(s.Answer) as Total
                    FROM Question q
                    LEFT JOIN Answer a ON a.ID_Question = q.ID_Question
                        AND a.ID_Survey = q.ID_Survey
                    LEFT JOIN Surveyed_Answer s ON s.ID_Question = a.ID_Question 
                        AND s.ID_Survey = a.ID_Survey
                    WHERE q.ID_Survey = ?
                    AND s.Answer LIKE CONCAT("%", a.Answer, "%")
                    GROUP BY 1,2,3
                    
                    UNION ALL
                    
                    SELECT q.ID_Question, q.Question, s.Answer, COUNT(s.Answer) as Total
                    FROM Question q
                    LEFT JOIN Surveyed_Answer s ON s.ID_Question = q.ID_Question 
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
                    FROM Question q
                    LEFT JOIN Surveyed_Answer s ON s.ID_Question = q.ID_Question 
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




router.get('/excel/:id', (req, res)=>{
    const {id} = req.params;
    var wb = new xl.Workbook();

    var ws = wb.addWorksheet('DATOS');

    var style= wb.createStyle({
        font:{
            color: '#040404',
            size: 12,
        }
    });

    const query = `SELECT q.ID_Question, q.Question, a.Answer, COUNT(s.Answer) as Total
                    FROM Question q
                    LEFT JOIN Answer a ON a.ID_Question = q.ID_Question
                        AND a.ID_Survey = q.ID_Survey
                    LEFT JOIN Surveyed_Answer s ON s.ID_Question = a.ID_Question 
                        AND s.ID_Survey = a.ID_Survey
                    WHERE q.ID_Survey = ?
                    AND s.Answer LIKE CONCAT("%", a.Answer, "%")
                    GROUP BY 1,2,3
                    
                    UNION ALL
                    
                    SELECT q.ID_Question, q.Question, s.Answer, COUNT(s.Answer) as Total
                    FROM Question q
                    LEFT JOIN Surveyed_Answer s ON s.ID_Question = q.ID_Question 
                        AND s.ID_Survey = q.ID_Survey
                    WHERE q.ID_Survey = ?
                    AND q.Type <> 'checkbox'
                    AND q.Type <> 'select'
                    AND q.Type <> 'radio'
                    GROUP BY 1,2,3`

                db.query( query ,[id, id], (err, rows, fields) =>{
                if(!err){
                    ws.cell(1,1).string("Answer").style(style);
                    ws.cell(1,2).string("Question").style(style);
                    ws.cell(1,3).string("Total").style(style);
                    let j=2;
                    for (let i=0; i<rows.length; i++){
                        ws.cell(j,1).string(rows[i].Answer).style(style);
                        ws.cell(j,2).string(rows[i].Question).style(style);
                        ws.cell(j,3).number(rows[i].Total).style(style);
                        j++;
                    }
                    console.log("Excel generado");
                    wb.write(`FileName.xlsx`, res);
                    // const pathExcel = path.join(__dirname, '', 'Encuesta.xlsx');

                    // wb.write(pathExcel, function (err, stats){
                    //     if (err){
                    //         console.log(err);
                    //     }else{
                    //         function downloadFile(){
                    //             res.download(pathExcel);
                    //         }
                    //         downloadFile();
                    //         return false;
                    //     }
                    // })
                }else{
                console.log(err);
                }
                });
    

});


module.exports = router;