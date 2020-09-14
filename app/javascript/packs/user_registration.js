const { phoneFormat } = require('./utils');

let phone1 = document.getElementById('user_phone1');
let phone2 = document.getElementById('user_phone2');
let accountType = document.getElementById('user_account_type');
let cpf = document.getElementById('cpf_field');

phoneFormat(phone1);
phoneFormat(phone2);

if (accountType.value != 'Ponto de Entrega') {
  cpf.style.display = 'none'
}
accountType.addEventListener('input', (event) => {
  if (event.target.value == 'Ponto de Entrega') {
    cpf.style.display = 'block'
  } else {
    cpf.style.display = 'none'
  }
});

