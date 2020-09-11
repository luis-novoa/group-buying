const phone1 = document.getElementById('user_phone1');

const countNumbers = (string) => {
  const regex = /\d/g
  return (string.match(regex) || []).length
}

phone1.addEventListener('keyup', (event) => {
  let input = phone1.value
  let inputNumbers = countNumbers(input)

  if (inputNumbers == 2 && input.length == 2) {
    phone1.value = `(${phone1.value}) `
  } else if (input.length < 4) {
    phone1.value.replace(/(\(|\))/g, '')
  } else if (input.length == 9 && inputNumbers == 6 && event.key != 'Backspace') {
    phone1.value += '-'
  } else if (input.length == 15 && inputNumbers == 11) {
    phone1.value = phone1.value.replace(/-/g, '')
    phone1.value = phone1.value.substring(0, 10) + '-' + phone1.value.substring(10, 14)
  } else if (input.length == 14 && inputNumbers == 10) {
    phone1.value = phone1.value.replace(/-/g, '')
    phone1.value = phone1.value.substring(0, 9) + '-' + phone1.value.substring(9, 13)
  }
});