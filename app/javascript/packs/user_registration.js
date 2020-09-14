const { phoneFormat, countNumbers, addressFormat } = require('./utils');

let phone1 = document.getElementById('user_phone1');
let phone2 = document.getElementById('user_phone2');
let accountType = document.getElementById('user_account_type');
let cpf = document.getElementById('cpf_field');
let cpfInput = document.getElementById('user_cpf');
let address = document.getElementById('user_address');
let addressStreet = document.getElementById('address_street');
let addressNumber = document.getElementById('address_number');
let addressInfo = document.getElementById('address_additional_info');

phoneFormat(phone1);
phoneFormat(phone2);
addressFormat(address, addressStreet, addressNumber, addressInfo);

address.style.display = 'none';
if (accountType.value != 'Ponto de Entrega') {
  cpf.style.display = 'none';
}
accountType.addEventListener('input', (event) => {
  if (event.target.value == 'Ponto de Entrega') {
    cpf.style.display = 'block'
  } else {
    cpf.style.display = 'none'
  }
});

cpfInput.addEventListener('keyup', () => {
  let input = cpfInput.value
  let inputNumbers = countNumbers(input)
  let lastIndex = input.length - 1

  if ((inputNumbers == 4 && input.length == 4) || (inputNumbers == 7 && input.length == 8)) {
    cpfInput.value = input.substring(0, lastIndex) + '.' + input[lastIndex]
  } else if (inputNumbers == 10 && input.length == 12) {
    cpfInput.value = input.substring(0, lastIndex) + '-' + input[lastIndex]
  }
});