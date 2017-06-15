require 'rack/test'
require './main'

describe UserSegmentation::API do
    include Rack::Test::Methods

    Mongo::Logger.logger.level = ::Logger::FATAL

    def app
        UserSegmentation::API
    end

    def create_user
        {
            :_id => 'annie',
            :email => 'annie@email.com',
            :name => 'Annie A.',
            :age => 30,
            :state => 'SC',
            :job => 'dev'
        }
    end

    after(:all) do
        UserSegmentation::API.class_variable_get(:@@client).database.drop()
    end

    context 'GET /api/v1/users (without items)' do
        it 'should get an empty list' do
            success_msg = []

            get '/api/v1/users'
            expect(last_response.body).to eq success_msg.to_json
            expect(last_response.status).to eq(200)
        end
    end

    context 'GET /api/v1/users (with items)' do
        user1 = nil
        user2 = nil
        user3 = nil
        user4 = nil
        before(:all) do
            user1 = create_user

            user2 = create_user
            user2[:_id] = 'john'
            user2[:name] = 'John H.'
            user2[:age] = 50
            user2[:state] = 'SP'

            user3 = create_user
            user3[:_id] = 'maria'
            user3[:name] = 'Maria W.'
            user3[:age] = 40

            user4 = create_user
            user4[:_id] = 'paul'
            user4[:name] = 'Paul Z.'

            post '/api/v1/users', user1.to_json, 'CONTENT_TYPE' => 'application/json'
            post '/api/v1/users', user2.to_json, 'CONTENT_TYPE' => 'application/json'
            post '/api/v1/users', user3.to_json, 'CONTENT_TYPE' => 'application/json'
            post '/api/v1/users', user4.to_json, 'CONTENT_TYPE' => 'application/json'
        end

        it 'should get a list of all users' do
            get '/api/v1/users'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user2.stringify_keys()
            expect(parsed_body[2]).to eq user3.stringify_keys()
            expect(parsed_body[3]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with name Annie A.' do
            get '/api/v1/users?name=Annie%20A.'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with 30 years' do
            get '/api/v1/users?age=30'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with 30 years and live in SC' do
            get '/api/v1/users?age=30&state=SC&logic_op=and'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(2)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with 30 years or live in SC' do
            get '/api/v1/users?age=30&state=SC&logic_op=or'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user3.stringify_keys()
            expect(parsed_body[2]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get an empty list due to no user meeting the criterias' do
            success_msg = []
            get '/api/v1/users?age=31'
            expect(last_response.body).to eq success_msg.to_json
            expect(last_response.status).to eq(200)
        end

        it 'fail for invalid query parameter' do
            valid_query_params = ['logic_op', 'email', 'name', 'age', 'state', 'job']
            error_msg = {
                :error => 'Invalid query',
                :detail => "The only valid query params are #{valid_query_params}"
            }

            get '/api/v1/users?state=SC&age=30&blah=blah'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(400)
        end

        it 'fail for invalid logic operator' do
            valid_logic_ops = ['and', 'or']
            error_msg = {
                :error => 'Invalid query',
                :detail => "The only valid logic operators are #{valid_logic_ops}"
            }

            get '/api/v1/users?state=SC&age=30&logic_op=blah'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(400)
        end
    end
end
