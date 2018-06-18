Gem::Specification.new do |s|
  s.name        = 'prawn_report'
  s.version     = '1.9.23'
  s.licenses    = ['MIT']
  s.summary     = 'Prawn Report makes it easy to create PDF reports.'
  s.description = 'Prawn report is a class repository wich uses prawn gem capabilities to generate PDF documents in order to make it easy to create real life reports.'
  s.authors     = ['Ricardo Acras', 'Egon Hilgenstieler', 'Juliano Andrade', 'Wellington Torrejais']
  s.email       = ['ricardo@acras.com.br', 'julianoch@gmail.com', 'egon@acras.com.br', 'wtds.trabalho@gmail.com']
  s.files       = Dir['lib/**/*.rb'] + Dir['generators/**/*.rb'] + Dir['repo/**/*.rb'] + Dir['app/**/*.rb']
  s.homepage    = 'http://www.acras.com.br/'
  s.metadata    = { 'source_code_uri' => 'https://github.com/hotsoft/prawn_reports/' }
  s.date        = '2018-06-18'
end
