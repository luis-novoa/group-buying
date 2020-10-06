const { addressFormat } = require('./utils');

let address = document.getElementById('user_address');
let addressStreet = document.getElementById('address_street');
let addressNumber = document.getElementById('address_number');
let addressInfo = document.getElementById('address_additional_info');

addressFormat(address, addressStreet, addressNumber, addressInfo);

address.style.display = 'none';