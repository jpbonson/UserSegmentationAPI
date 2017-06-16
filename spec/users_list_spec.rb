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
            user2[:job] = 'devops'

            user3 = create_user
            user3[:_id] = 'maria'
            user3[:name] = 'Maria W.'
            user3[:job] = 'people manager'
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
            expect(parsed_body.length).to be(4)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user2.stringify_keys()
            expect(parsed_body[2]).to eq user3.stringify_keys()
            expect(parsed_body[3]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with name Annie A.' do
            get '/api/v1/users?name=Annie%20A.'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(1)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with 30 years' do
            get '/api/v1/users?age=30'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(2)
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
            expect(parsed_body.length).to be(3)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user3.stringify_keys()
            expect(parsed_body[2]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with less or equal 30 years' do
            get '/api/v1/users?age=30&age_op=lte'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(2)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with more or equal 40 years' do
            get '/api/v1/users?age=40&age_op=gte'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(2)
            expect(parsed_body[0]).to eq user2.stringify_keys()
            expect(parsed_body[1]).to eq user3.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with less than 35 years or live in SP' do
            get '/api/v1/users?age=35&age_op=lt&state=SP&logic_op=or'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(3)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user2.stringify_keys()
            expect(parsed_body[2]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with more than 30 years and live in SP' do
            get '/api/v1/users?age=30&age_op=gt&state=SP'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(1)
            expect(parsed_body[0]).to eq user2.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with dev equal to the job string' do
            get '/api/v1/users?job=dev'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(2)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with dev in the job string' do
            get '/api/v1/users?job_regex=dev'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(3)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user2.stringify_keys()
            expect(parsed_body[2]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with people at start of the job string' do
            get '/api/v1/users?job_regex=\Apeople'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(1)
            expect(parsed_body[0]).to eq user3.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get a list of users with dev at end of the job string' do
            get '/api/v1/users?job_regex=dev\z'
            parsed_body = JSON.parse(last_response.body)
            expect(parsed_body.length).to be(2)
            expect(parsed_body[0]).to eq user1.stringify_keys()
            expect(parsed_body[1]).to eq user4.stringify_keys()
            expect(last_response.status).to eq(200)
        end

        it 'should get an empty list due to no user meeting the criterias' do
            success_msg = []
            get '/api/v1/users?age=31'
            expect(last_response.body).to eq success_msg.to_json
            expect(last_response.status).to eq(200)
        end

        it 'fail for invalid query parameter' do
            valid_query_params = ['logic_op', 'age_op', 'email', 'name', 'age',
                'state', 'job', 'email_regex', 'name_regex', 'job_regex']
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

        it 'fail for invalid numeric operator' do
            valid_logic_ops = ['lte', 'lt', 'gte', 'gt']
            error_msg = {
                :error => 'Invalid query',
                :detail => "The only valid numeric operators are #{valid_logic_ops}"
            }

            get '/api/v1/users?state=SC&age=30&age_op=blah'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(400)
        end

        it 'fail for email regex and non-regex parameter at the same time' do
            error_msg = { :error => 'email, email_regex are mutually exclusive' }
            get '/api/v1/users?email=wtf@email.com&email_regex=wtf@email.com'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(400)
        end

        it 'fail for name regex and non-regex parameter at the same time' do
            error_msg = { :error => 'name, name_regex are mutually exclusive' }
            get '/api/v1/users?name=cris&name_regex=cris'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(400)
        end

        it 'fail for job regex and non-regex parameter at the same time' do
            error_msg = { :error => 'job, job_regex are mutually exclusive' }
            get '/api/v1/users?job=dev&job_regex=dev'
            expect(last_response.body).to eq error_msg.to_json
            expect(last_response.status).to eq(400)
        end
    end
end
