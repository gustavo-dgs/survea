

window.addEventListener("load", async () => {
    if ('serviceWorker' in navigator) {
        const reg = await navigator.serviceWorker.register("service-workers.js")
        console.log("Service worker has been registered for scope: " + reg.scope);
    }
});


axios.defaults.baseURL = 'http://localhost:4000/api';
//https://survea-webapp.azurewebsites.net/api

let containerState = true;

document.querySelector('.log-sign__box__container__login')
    .addEventListener("submit", (event) => {
        event.preventDefault()
        loginUser(event);
    });


function switchForm() {
    const logSing__box = document.querySelector('.log-sing__box');
    const login = document.querySelector('.log-sign__box__container__login');
    const register = document.querySelector('.log-sign__box__container__register');

    if (containerState) {
        logSing__box.style.height = '600px';
    } else {
        logSing__box.style.height = '400px';
    }

    login.classList.toggle('disabled');
    register.classList.toggle('disabled');

    containerState = !containerState;
}

document.querySelector('.log-sign__box__container__register')
    .addEventListener("submit", (event) => {
        event.preventDefault()
        registerUser(event);
    });

function registerUser(event) {
    event.preventDefault();
    const arr = Array.from(event.target.elements);

    if (arr.some(x => x.value === '')) {
        alert('Error: the form is not complete');
        return;
    }

    if (arr[3].value !== arr[4].value) {
        alert('Error: the passwords do not match');
        return;
    }

    const user = {
        name: arr[0].value,
        lastname: arr[1].value,
        email: arr[2].value,
        password: arr[3].value
    }

    axios.post('signup', user)
        .then(res => {
            if (res.data.code === 200) {
                // this.$router.push(`/user/${res.data.User.ID_User}`);
                alert(`Se ha registrado correctamente user: ${res.data.User.ID_User}`);
            } else {
                alert(res.data.msg);
            }
        })
        .catch(err => console.log(err));


}

function loginUser(event) {
    const arr = Array.from(event.target.elements);

    if (arr.some(x => x.value === '')) {
        alert('Error: the form is not complete');
        return;
    }

    axios.get(`login`, {
        params: {
            email: arr[0].value,
            password: arr[1].value
        }
    })
        .then(res => {
            if (res.data.code === 200) {
                // this.$router.push(`/user/${res.data.User.ID_User}`);
                alert(`Se ha iniciado sesion correctamente user: ${res.data.User.ID_User}`);
            } else {
                alert(res.data);
            }
        })
        .catch(err => console.log(err));
}


var db;

const createDb = async() => {
    db = await openDB('cookbook', 1, {
        upgrade(db, oldVersion, newVersion, transaction) {
            // Switch over the oldVersion, *without breaks*, to allow the database to be incrementally upgraded.
            switch (oldVersion) {
                case 0:
                // Placeholder to execute when database is created (oldVersion is 0)
                case 1:
                    // Create a store of objects
                    const store = db.createObjectStore('recipes', {
                        // The `id` property of the object will be the key, and be incremented automatically
                        autoIncrement: true,
                        keyPath: 'id'
                    });
                    // Create an index called `name` based on the `type` property of objects in the store
                    store.createIndex('type', 'type');
    
            }
        }
    });
    
}

createDb();


async function persistData() {
    if (navigator.storage && navigator.storage.persist) {
        const result = await navigator.storage.persist();
        console.log(`Data persisted: ${result}`);
    }
}

persistData();

async function addData() {
    const cookies = {
        name: "Helado",
        type: "dessert",
        cook_time_minutes: 25
    };
    const tx = await db.transaction('recipes', 'readwrite');
    const store = tx.objectStore('recipes');
    store.add(cookies);
    await tx.done;
}

document.querySelector('.add-button').addEventListener('click', event => {
    addData()
});


async function getData(id) {
    const tx = await db.transaction('recipes', 'readonly')
    const store = tx.objectStore('recipes');
    // Because in our case the `id` is the key, we would
    // have to know in advance the value of the id to
    // retrieve the record
    const value = await store.get(id);
    console.log(value);
    return value;
}

document.querySelector('.get-button').addEventListener('click', async event => {
    const titulo = document.querySelector('.titulo');
    const value = getData([1, 6]);
    titulo.innerHTML = value;
});

async function deleteData(id) {
    const tx = await db.transaction('recipes', 'readwrite')
    const store = tx.objectStore('recipes');
    // Because in our case the `id` is the key, we would
    // have to know in advance the value of the id to
    // retrieve the record
    store.delete(id);
    await tx.done;
    showResult("Beatle deleted from the database");
}

document.querySelector('.delete-button').addEventListener('click', async event => {
    deleteData(7);
});
