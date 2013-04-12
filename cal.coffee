env = process.argv[2]
switch env
  when 'dev'
    domain = 'dev.www.tiantong99.com'
  when 'test'
    domain = 'test.www.tiantong99.com'
  when 'release'
    domain = 'www.tiantong99.com'
  else
    console.log 'coffee replace-domain.coffee <enviroment>\n envoriment should be dev, test, release'
    return