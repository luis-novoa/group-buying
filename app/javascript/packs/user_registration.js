const { phoneFormat } = require('./utils');

let phone1 = document.getElementById('user_phone1');
let phone2 = document.getElementById('user_phone2');

phoneFormat(phone1);
phoneFormat(phone2);