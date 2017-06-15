require 'grape'
require 'mongo'

module UserSegmentation
    class API < Grape::API
        include Mongo

        version 'v1', using: :path
        format :json
        prefix :api

        settings = {
            :mongodb_host => '127.0.0.1',
            :port => '27017',
            :database => 'segmentation-api-dev'
        }
        if ENV['RACK_ENV'] == 'test'
            settings[:database] = 'segmentation-api-test'
        elsif ENV['RACK_ENV'] == 'production'
            settings[:database] = 'segmentation-api-prod'
        end

        mongo_uri = "mongodb://#{settings[:mongodb_host]}:#{settings[:port]}/#{settings[:database]}"
        if ENV['MONGODB_URI']
            mongo_uri = ENV['MONGODB_URI']
        end

        @@client = Mongo::Client.new(mongo_uri)
        @@collection = @@client[:users]

        helpers do
            VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

            VALID_STATES = ['AC','AL','AP','AM','BA','CE','DF','ES','GO','MA',
                'MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO',
                'RR','SC','SP','SE','TO']

            params :user_post do
                requires :_id, type: String, allow_blank: false, regexp: /\A\w+\z/, desc: 'Unique id (alphanumerical)'
                requires :email, type: String, allow_blank: false, regexp: VALID_EMAIL_REGEX, desc: 'Email'
                requires :name, type: String, allow_blank: false, desc: 'Name'
                requires :age, type: Integer, values: 0..150, desc: 'Age (0-150)'
                requires :state, type: String, values: VALID_STATES, desc: 'State (BR)'
                requires :job, type: String, allow_blank: false, desc: 'Job'
            end

            params :user_optional do
                optional :email, type: String, allow_blank: false, regexp: VALID_EMAIL_REGEX, desc: 'Email'
                optional :name, type: String, allow_blank: false, desc: 'Name'
                optional :age, type: Integer, values: 0..150, desc: 'Age (0-150)'
                optional :state, type: String, values: VALID_STATES, desc: 'State (BR)'
                optional :job, type: String, allow_blank: false, desc: 'Job'
            end

            def logger
                API.logger
            end
        end

        resource :users do
            desc 'Return an user by id.'
            get ':_id' do
                result = @@collection.find({ :_id => params[:_id] }, { :limit => 1 }).first
                if not result
                    error!({ error: 'User not found', detail: '' }, 404)
                end
                result
            end

            desc 'Return a list of users.'
            params do
                use :user_optional
            end
            get do
                valid_query_params = ['email', 'name', 'age', 'state', 'job']
                if not params.keys.all? {|key| valid_query_params.include?(key) }
                    error!({
                        error: 'Invalid query',
                        detail: "The only valid query params are #{valid_query_params}"
                    }, 400)
                end
                @@collection.find(params).to_a
            end

            desc 'Create an user.'
            params do
                use :user_post
            end
            post do
                if @@collection.find({ :_id => params[:_id] }, { :limit => 1 }).first
                    error!({ error: 'User already exists', detail: '' }, 409)
                end

                begin
                    result = @@collection.insert_one(params)
                    if result.ok?
                        {}
                    else
                        msg_detail = "Could not create user, n: #{result.n}, ok: #{result.ok?}"
                        error!({ error: 'Database error', detail: msg_detail }, 500)
                    end
                rescue Exception => e
                    error!({ error: 'Database error', detail: e.message }, 500)
                end
            end

            desc 'Update an user by id.'
            params do
                requires :_id, type: String, allow_blank: false, regexp: /\A\w+\z/, desc: 'Unique id (alphanumerical)'
                use :user_optional
            end
            put ':user_id' do
                if params[:user_id] != params[:_id]
                    error!(
                    {
                        error: 'User id in request is different from id in the object',
                        detail: ''
                    }, 400)
                end
                user_id = params[:user_id]
                params.delete(:user_id)
                params.delete(:_id)
                result = @@collection.find_one_and_update( { :_id => user_id }, '$set' => params )
                if not result
                    error!({ error: 'User not found', detail: '' }, 404)
                end
                {}
            end

            desc 'Delete an user by id.'
            delete ':_id' do
                result = @@collection.find_one_and_delete( { :_id => params[:_id] } )
                if not result
                    error!({ error: 'User not found', detail: '' }, 404)
                end
                result
            end
        end
    end
end
