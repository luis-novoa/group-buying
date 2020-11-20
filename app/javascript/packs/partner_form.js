const { phoneFormat, countNumbers, addressFormat } = require('./utils');

let phone1 = document.getElementById('partner_phone1');
let phone2 = document.getElementById('partner_phone2');
let cnpj = document.getElementById('partner_cnpj');
let address = document.getElementById('partner_address');
let addressStreet = document.getElementById('address_street');
let addressNumber = document.getElementById('address_number');
let addressInfo = document.getElementById('address_additional_info');

phoneFormat(phone1);
phoneFormat(phone2);
addressFormat(address, addressStreet, addressNumber, addressInfo);

address.style.display = 'none';

cnpj.addEventListener('keyup', () => {
  let input = cnpj.value
  let inputNumbers = countNumbers(input)
  let lastIndex = input.length - 1

  if ((inputNumbers == 3 && input.length == 3) || (inputNumbers == 6 && input.length == 7)) {
    cnpj.value = input.substring(0, lastIndex) + '.' + input[lastIndex]
  } else if (inputNumbers == 9 && input.length == 11) {
    cnpj.value = input.substring(0, lastIndex) + '/' + input[lastIndex]
  } else if (inputNumbers == 13 && input.length == 16) {
    cnpj.value = input.substring(0, lastIndex) + '-' + input[lastIndex]
  }
});