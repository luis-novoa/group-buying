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

exports.phoneFormat = phoneFormat;