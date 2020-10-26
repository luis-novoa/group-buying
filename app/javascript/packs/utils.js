function countNumbers(string) {
  const regex = /\d/g
  return (string.match(regex) || []).length
}

function phoneFormat(phone) {
  phone.addEventListener('keyup', (event) => {
    let input = phone.value
    let inputNumbers = countNumbers(input)

    if (inputNumbers == 2 && input.length == 2) {
      phone.value = `(${phone.value}) `
    } else if (input.length < 4) {
      phone.value.replace(/(\(|\))/g, '')
    } else if (input.length == 9 && inputNumbers == 6 && event.key != 'Backspace') {
      phone.value += '-'
    } else if (input.length == 15 && inputNumbers == 11) {
      phone.value = phone.value.replace(/-/g, '')
      phone.value = phone.value.substring(0, 10) + '-' + phone.value.substring(10, 14)
    } else if (input.length == 14 && inputNumbers == 10) {
      phone.value = phone.value.replace(/-/g, '')
      phone.value = phone.value.substring(0, 9) + '-' + phone.value.substring(9, 13)
    }
  });
}

function addressFormat(address, addressStreet, addressNumber, addressInfo) {
  function updateAddress() {
    if (addressInfo.value.length == 0) {
      address.value = `${addressStreet.value}, ${addressNumber.value}`;
    } else {
      address.value = `${addressStreet.value}, ${addressNumber.value}, ${addressInfo.value}`;
    }
  }

  addressStreet.style.display = 'inline-block';
  addressStreet.addEventListener('keyup', () => {
    if (addressStreet.value.length > 0) {
      addressStreet.value = addressStreet.value.charAt(0).toUpperCase() + addressStreet.value.slice(1);
    }
    updateAddress();
  });

  addressNumber.addEventListener('keyup', () => {
    updateAddress();
  });

  addressInfo.addEventListener('keyup', () => {
    updateAddress();
  });
}

exports.phoneFormat = phoneFormat;
exports.countNumbers = countNumbers;
exports.addressFormat = addressFormat;