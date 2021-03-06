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

    context 'POST /api/v1/users' do
        it 'should create user' do
            user = create_user
            success_msg = {}

            post '/api/v1/users', user.to_json, 'CONTENT_TYPE' => 'application/json'
            expect(last_response.body).to eq success_msg.to_json
            expect(last_response.status).to eq(201)
        end

        it 'fail for user already created' do
            user = create_user
            error_msg = {
                :error => 'User already exists',
                :detail => ''
            }

            post '/api/v1/users', user.to_json, 'CONTENT_TYPE' => 'application/json'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(409)
        end

        context 'params validation' do
            context 'id' do
                expected_values = ['a b', '', nil, 'a!', '!a']
                expected_values.each do |val|
                    it "fail for invalid id #{val}" do
                        user = create_user
                        user[:_id] = val
                        post '/api/v1/users', user.to_json, 'CONTENT_TYPE' => 'application/json'
                        expect(last_response.status).to eq(400)
                    end
                end
            end

            context 'email' do
                expected_values = ['a', 123, '', nil, '@email.com', 'blahemail.com']
                expected_values.each do |val|
                    it "fail for invalid email #{val}" do
                        user = create_user
                        user[:email] = val
                        post '/api/v1/users', user.to_json, 'CONTENT_TYPE' => 'application/json'
                        expect(last_response.status).to eq(400)
                    end
                end
            end

            context 'name' do
                expected_values = ['', nil]
                expected_values.each do |val|
                    it "fail for invalid name #{val}" do
                        user = create_user
                        user[:name] = val
                        post '/api/v1/users', user.to_json, 'CONTENT_TYPE' => 'application/json'
                        expect(last_response.status).to eq(400)
                    end
                end
            end

            context 'age' do
                expected_values = ['', nil, 'old', -1, 151]
                expected_values.each do |val|
                    it "fail for invalid age #{val}" do
                        user = create_user
                        user[:age] = val
                        post '/api/v1/users', user.to_json, 'CONTENT_TYPE' => 'application/json'
                        expect(last_response.status).to eq(400)
                    end
                end
            end

            context 'state' do
                expected_values = ['', nil, 'AB', 123]
                expected_values.each do |val|
                    it "fail for invalid state #{val}" do
                        user = create_user
                        user[:state] = val
                        post '/api/v1/users', user.to_json, 'CONTENT_TYPE' => 'application/json'
                        expect(last_response.status).to eq(400)
                    end
                end
            end

            context 'job' do
                expected_values = ['', nil]
                expected_values.each do |val|
                    it "fail for invalid job #{val}" do
                        user = create_user
                        user[:job] = val
                        post '/api/v1/users', user.to_json, 'CONTENT_TYPE' => 'application/json'
                        expect(last_response.status).to eq(400)
                    end
                end
            end
        end
    end

    context 'PUT /api/v1/users/:id' do
        it 'should update user' do
            user = create_user
            user[:name] = 'Annie B.'
            success_msg = {}

            put "/api/v1/users/#{user[:_id]}", user.to_json, 'CONTENT_TYPE' => 'application/json'
            expect(last_response.body).to eq success_msg.to_json
            expect(last_response.status).to eq(200)
        end

        it 'should partially update user' do
            user = {
                :_id => 'annie',
                :name => 'Annie C.'
            }
            success_msg = {}

            put "/api/v1/users/#{user[:_id]}", user.to_json, 'CONTENT_TYPE' => 'application/json'
            expect(last_response.body).to eq success_msg.to_json
            expect(last_response.status).to eq(200)
        end

        it 'fail for user that does not exist' do
            user = create_user
            user[:_id] = 'WHATEVER'
            error_msg = {
                :error => 'User not found',
                :detail => ''
            }

            put "/api/v1/users/WHATEVER", user.to_json, 'CONTENT_TYPE' => 'application/json'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(404)
        end

        it 'fail for incompatible ids in request and object' do
            user = create_user
            error_msg = {
                :error => 'User id in request is different from id in the object',
                :detail => ''
            }

            put "/api/v1/users/WHATEVER", user.to_json, 'CONTENT_TYPE' => 'application/json'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(400)
        end
    end

    context 'GET /api/v1/users/:id' do
        it 'should get user' do
            user = create_user
            user[:name] = 'Annie C.'

            get "/api/v1/users/#{user[:_id]}"
            expect(last_response.body).to eq user.to_json
            expect(last_response.status).to eq(200)
        end

        it 'fail for user that does not exist' do
            error_msg = {
                :error => 'User not found',
                :detail => ''
            }

            get '/api/v1/users/WHATEVER'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(404)
        end
    end

    context 'DELETE /api/v1/users/:id' do
        it 'should delete user' do
            user = create_user
            user[:name] = 'Annie C.'

            delete "/api/v1/users/#{user[:_id]}"
            expect(last_response.body).to eq user.to_json
            expect(last_response.status).to eq(200)
        end

        it 'fail for user that does not exist' do
            error_msg = {
                :error => 'User not found',
                :detail => ''
            }

            delete '/api/v1/users/WHATEVER'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(404)
        end
    end
end
