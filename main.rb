require 'grape'

module UserSegmentation
    class API < Grape::API
        version 'v1', using: :path
        format :json
        prefix :api

        self.logger.level = Logger::INFO

        $sample_data = {}

        helpers do
            VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

            VALID_STATES = ['AC','AL','AP','AM','BA','CE','DF','ES','GO','MA',
                'MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO',
                'RR','SC','SP','SE','TO']

            params :user do
                requires :id, type: String, allow_blank: false, regexp: /\A\w+\z/, desc: 'Unique id (alphanumerical)'
                requires :email, type: String, allow_blank: false, regexp: VALID_EMAIL_REGEX, desc: 'Email'
                requires :name, type: String, allow_blank: false, desc: 'Name'
                requires :age, type: Integer, values: 0..150, desc: 'Age (0-150)'
                requires :state, type: String, values: VALID_STATES, desc: 'State (BR)'
                requires :job, type: String, allow_blank: false, desc: 'Job'
            end

            def update_user_data(params)
                $sample_data[params[:id]] = {
                    :id => params[:id],
                    :email => params[:email],
                    :name => params[:name],
                    :age => params[:age],
                    :state => params[:state],
                    :job => params[:job]
                }
                {}
            end

            def logger
                API.logger
            end
        end

        resource :users do
            desc 'Return an user by id.'
            get ':id' do
                if not $sample_data.key?(params[:id])
                    error!({ error: 'User not found', detail: '' }, 404)
                end
                $sample_data[params[:id]]
            end

            desc 'Return a list of users.'
            get do
                $sample_data.values
            end

            desc 'Create an user.'
            params do
                use :user
            end
            post do
                if $sample_data.key?(params[:id])
                    error!({ error: 'User already exists', detail: '' }, 409)
                end
                update_user_data(params)
            end

            desc 'Update an user by id.'
            params do
                use :user
            end
            put ':user_id' do
                if params[:user_id] != params[:id]
                    error!(
                    {
                        error: 'User id in request is different from id in the object',
                        detail: ''
                    }, 400)
                end
                if not $sample_data.key?(params[:id])
                    error!({ error: 'User not found', detail: '' }, 404)
                end
                update_user_data(params)
            end

            desc 'Delete an user by id.'
            delete ':id' do
                if not $sample_data.key?(params[:id])
                    error!({ error: 'User not found', detail: '' }, 404)
                end
                $sample_data.delete(params[:id])
            end
        end
    end
end
