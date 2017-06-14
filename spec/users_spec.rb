require 'rack/test'
require './main'

describe UserSegmentation::API do
    include Rack::Test::Methods

    def app
        UserSegmentation::API
    end

    user = {
        :id => "annie",
        :email => "annie@emailcom",
        :name => "Annie A.",
        :age => 30,
        :state => "SC",
        :job => "dev"
    }

    context 'GET /api/v1/users/:id' do
        it 'fail for user that does not exist' do
            error_msg = {
                :error => 'User not found',
                :detail => ''
            }

            get "/api/v1/users/#{user[:id]}"
            expect(last_response.status).to eq(404)
            expect(last_response.body).to eq error_msg.to_json
        end
    end
end
