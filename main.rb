require 'sinatra'
require 'grape'

module UserSegmentation
    class API < Grape::API
        version 'v1', using: :path
        format :json
        prefix :api

        self.logger.level = Logger::INFO

        $sample_data = {}

        helpers do
            params :user do
                requires :email, type: String, desc: 'Email (used as unique id)'
                requires :name, type: String, desc: 'Name'
                requires :age, type: Integer, desc: 'Age'
                requires :state, type: String, desc: 'State'
                requires :job, type: String, desc: 'Job'
            end

            def update_user_data(params)
                $sample_data[params[:email]] = {
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

            desc 'Create an user.'
            params do
                use :user
            end
            post do
                if $sample_data.key?(params[:email])
                    error!({ error: 'User already exists', detail: '' }, 409)
                end
                update_user_data(params)
            end

            desc 'Update an user by id.'
            params do
                use :user
            end
            put ':id' do
                if params[:email] != params[:id]
                    error!(
                    {
                        error: 'User id in request is different from email in the object',
                        detail: 'Id and email must be equal since email is used as the unique identifier'
                    }, 400)
                end
                if not $sample_data.key?(params[:email])
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
