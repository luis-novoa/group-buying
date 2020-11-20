const { addressFormat } = require('./utils');

let hiddenFields = document.getElementsByClassName('hidden');
let address = document.getElementById('partner_address');
let addressStreet = document.getElementById('address_street');
let addressNumber = document.getElementById('address_number');
let addressInfo = document.getElementById('address_additional_info');

address.style.display = 'none';
Array.prototype.forEach.call(hiddenFields, (field) => {
  field.style.display = 'block';
});

addressFormat(address, addressStreet, addressNumber, addressInfo);