module.exports = (id, position, personname, positionname, startdate) => {
  reference = {
    P854: 'https://www.regjeringen.no/en/the-government/solberg/members-of-the-government-2/id543170/'
    P1476: {
      text: 'Members of the Government',
      language: 'en',
    },
    P813: new Date().toISOString().split('T')[0],
    P407: 'Q1860', // language: English
  }

  qualifier = {
    P580: '2013-10-16',
    P5054: 'Q15020889', // Solberg's Cabinet
  }

  if(startdate)      qualifier['P580']  = startdate
  if(personname)     reference['P1810'] = personname
  if(positionname)   reference['P1932'] = positionname

  return {
    id,
    claims: {
      P39: {
        value: position,
        qualifiers: qualifier,
        references: reference,
      }
    }
  }
}
