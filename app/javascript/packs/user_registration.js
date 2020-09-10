const sendButton = document.getElementById('send');

sendButton.addEventListener('click', () => {
  let address = document.getElementById('user_address');
  const addressNumber = document.getElementById('address_number');
  const addressAddInfo = document.getElementById('address_additional_info');
  address += `, ${addressNumber}`;
  if (addressAddInfo != '') {
    address += `, ${addressAddInfo}`
  }


  const ddd1 = document.getElementById('ddd1');
  const phone1FirstHalf = document.getElementById('phone1_fist_half');
  const phone1SecondHalf = document.getElementById('phone1_second_half');
  let phone1 = document.getElementById('user_phone1');
  phone1 = `(${ddd1}) ${phone1FirstHalf}-${phone1SecondHalf}`;
  console.log(phone1)

  const ddd2 = document.getElementById('ddd2');
  const phone2FirstHalf = document.getElementById('phone2_fist_half');
  const phone2SecondHalf = document.getElementById('phone2_second_half');
  let phone2 = document.getElementById('user_phone2');
  phone2 = `(${ddd2}) ${phone2FirstHalf}-${phone2SecondHalf}`;
});