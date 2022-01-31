export default {
    install: (app, option) => {

        app.config.globalProperties.$splitResulSet = function splitResulSet (resulSet, config, fatherId) {

            let model = [];
            
            //Por cada fila del resulset
            for (let row of resulSet) {
                
                let findFunction = (value, index, array) => {
                    return row[ config[0].thisId ] === value[ config[0].thisId ];
                };
        
                // Si es hijo del padre y no se repite el registro
                if (   (fatherId === undefined ||
                        fatherId === row[ config[0].linkId ]) &&
                        row[ config[0].thisId ] != null &&
                        model.findIndex(findFunction) === -1   ) {
                    
                    let obj = {};
        
                    //Agregar cada columna del resulset al nuevo modelo
                    for (let col of config[0].columns) {
        
                        obj[col] = row[col];
                    }
        
                    //Si llegamos al ultimo hijo paramos
                    if (config.length > 1) {
                        obj[config[0].son] = splitResulSet(resulSet, config.slice(1), 
                            row[config[0].thisId]);
                    }
        
                    model.push(obj);
                }
                
            }
        
            return model;    

        }
    }
}

 