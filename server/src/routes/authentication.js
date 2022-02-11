const express = require('express');

const router = express.Router();

const bcrypt = require('bcryptjs')
const db = require('../database');

var auth = (req, res, next) => {
    if (req.session.name)
        return next();
    else
        return res.json({ code: 401, status: false });
};

router.post('/signup', (req, res) => {

    const { name, lastname, email } = req.body;
    var passencryp = bcrypt.hashSync(req.body.password, 10);

    db.query('INSERT INTO User(Name, Lastname, Email, Password) VALUES (?,?,?,?)',
        [name, lastname, email, passencryp]
        , (err, rows, fields) => {
            if (!err) {
                res.json({ code: 200, status: true, msg: 'User succesfully created' });
            } else {
                res.json({ code: 402, status: false, msg: 'User not created', err: err });
            }
        })

});

router.get('/login', (req, res) => {
    const { email, password } = req.query;

    db.query('SELECT * FROM User WHERE Email = ?', [email], (err, rows, fields) => {
        
        if (!err && rows.length > 0) {
            const user = rows[0];
            bcrypt.compare(password, user.Password, (err, coinciden) => {
                if (err) {
                    res.json({ status: 402, err: err });
                } else {
                    if (coinciden) {
                        session = req.session;
                        session.name = rows[0].Name;
                        session.login = 1;
                        res.json({ code: 200, status: true, User: rows[0] })
                    } else {
                        res.json({ code: 402, status: false, msg: "Ingreso una contraseña erronea" })
                    }
                }
            });
        } else {
            res.json({ code: 402, status: false, msg: 'Usuario no coincide, registrate' });
        }
    })
});

router.get('/logout', (req, res) => {
    req.session.destroy();
    res.json({ code: 200, status: true, msg: "Logout" })
})

router.get('/content', auth, (req, res) => {
    console.log("logueado");
})


module.exports = router;