// wb ar add-source-name.js Q97131330-4C4A7FD7-C10F-4D38-B5FD-03F6EADF409A "Vassilios Demetriades" "Deputy Minister of Shipping"

module.exports = (guid, name, position) => ({
  guid,
  snaks: {
    P854: 'https://www.regjeringen.no/en/the-government/solberg/members-of-the-government-2/id543170/',
    P1476: {
      text: 'Members of the Government',
      language: 'en',
    },
    P813: new Date().toISOString().split('T')[0],
    P407: 'Q1860', // language: English
    P1810: name, // named as (Person)
    P1932: position, //stated as (Position)
  }
})
