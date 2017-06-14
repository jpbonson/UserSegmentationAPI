# User Segmentation API

API that allows the segmentation of users according to custom filters.

Ruby. Sinatra. Grape. MongoDB.

# How to Install

To install gem dependencies:
bundle install

# To Execute

Run:
rackup config.ru -p 9999

# Example

curl -v http://localhost:9999/api/v1/users

curl -H "Content-Type: application/json" -X POST -d '{"email":"xyz2", "name":"blah2"}' http://localhost:9999/api/v1/users

curl -H "Content-Type: application/json" -X PUT -d '{"email":"xyz2", "name":"blah222"}' http://localhost:9999/api/v1/users/xyz2

curl -X "DELETE" http://localhost:9999/api/v1/users/xyz2

# Some References

Ruby:
http://www.cheat-sheets.org/saved-copy/RubyCheat.pdf
http://www.rubyinside.com/ruby-cheat-sheet-734.html
http://shipit.resultadosdigitais.com.br/blog/composicao-e-heranca-no-ruby/
http://shipit.resultadosdigitais.com.br/blog/dicas-de-design-orientado-a-objetos-com-ruby-parte-3/
http://shipit.resultadosdigitais.com.br/blog/40-boas-praticas-de-ruby-parte-1/
http://shipit.resultadosdigitais.com.br/blog/40-boas-praticas-de-ruby-parte-2/
http://shipit.resultadosdigitais.com.br/blog/dicas-de-design-orientado-a-objetos-com-ruby-parte-1/
http://shipit.resultadosdigitais.com.br/blog/dicas-de-design-orientado-a-objetos-com-ruby-parte-2/
https://github.com/bbatsov/ruby-style-guide
http://ruby.bastardsbook.com/chapters/collections/
https://stackoverflow.com/questions/3422223/vs-in-ruby

APIs:
http://brisruby.org/building-apis-with-grape
https://phraseapp.com/blog/posts/best-practice-10-design-tips-for-apis/

Gems or gem-related:
https://rvm.io/
http://rack.github.io/
http://bundler.io/
http://www.sinatrarb.com/
http://www.ruby-grape.org/examples/
http://www.rubydoc.info/

https://github.com/ruby-grape/grape
https://github.com/katgironpe/sinatra-mongodb-grape

Heroku:
https://www.heroku.com/
https://devcenter.heroku.com/articles/rack

Mongodb:
https://docs.mongodb.com/manual/reference/method/db.collection.find/
https://github.com/mongodb/mongo-ruby-driver
https://stackoverflow.com/questions/30948024/filtering-elements-in-mongodb-collection-with-ruby
http://api.mongodb.com/ruby/current/Mongo/Collection/View.html

Tests:
http://blog.brianguthrie.com/2011/03/29/when-to-use-rspec-when-to-use-cucumber/
https://stackoverflow.com/questions/11762245/whats-the-difference-between-rspec-and-cucumber
https://github.com/teamcapybara/capybara
http://shipit.resultadosdigitais.com.br/blog/estruturando-seu-projeto-com-bdd-e-cucumber/
http://shipit.resultadosdigitais.com.br/blog/o-processo-de-garantia-de-qualidade-em-um-ambiente-agil/
http://shipit.resultadosdigitais.com.br/blog/rspec-performance-tips/
https://stackoverflow.com/questions/1479361/what-is-the-community-preferred-ruby-unit-testing-framework

Extras:
http://shipit.resultadosdigitais.com.br/blog/materiais-abertos-recomendados-onboarding-desenvolvedores/
http://shipit.resultadosdigitais.com.br/blog/ganhando-produtividade-com-clean-code/
https://stackoverflow.com/questions/5758276/how-do-i-install-ruby-gems-when-using-rvm
https://stackoverflow.com/questions/3009477/what-is-rubys-double-colon
http://shipit.resultadosdigitais.com.br/blog/o-processo-de-garantia-de-qualidade-em-um-ambiente-agil/
http://shipit.resultadosdigitais.com.br/blog/como-fazer-uma-boa-revisao-de-codigo/
http://shipit.resultadosdigitais.com.br/blog/evitando-problemas-com-elasticsearch-parte-1-analise/
http://shipit.resultadosdigitais.com.br/blog/alta-disponibilidade-e-tolerancia-a-falhas-com-mongodb/
