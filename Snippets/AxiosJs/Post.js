  const params = new URLSearchParams();
  params.append('firstName', 'value1');
  params.append('lastName', 'value2');


  axios.post('/api/documentstorage/', params)
  .then(function (response) {
      console.log(response);
  })
  .catch(function (error) {
      console.log(error);
  });
