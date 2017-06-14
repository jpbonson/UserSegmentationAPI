require 'sinatra'
require 'grape'

module UserSegmentation
    class API < Grape::API
        version 'v1', using: :path
        format :json
        prefix :api

        $sample_data = {}

        resource :users do
            desc 'Return an user by id.'
            params do
                requires :email, type: String, desc: 'Email (used as unique id)'
            end
            get ':email' do
                if not $sample_data.key?(params[:email])
                    error!({ error: 'User not found', detail: '' }, 404)
                end
                $sample_data[params[:email]]
            end

            desc 'Create an user.'
            params do
                requires :email, type: String, desc: 'Email (used as unique id)'
                requires :name, type: String, desc: 'Name'
            end
            post do
                if $sample_data.key?(params[:email])
                    error!({ error: 'User already exists', detail: '' }, 409)
                end
                $sample_data[params[:email]] = params[:name]
            end

            desc 'Update an user.'
            params do
                requires :email, type: String, desc: 'Email (used as unique id)'
                requires :name, type: String, desc: 'Name'
            end
            put ':email' do
                if not $sample_data.key?(params[:email])
                    error!({ error: 'User not found', detail: '' }, 404)
                end
                $sample_data[params[:email]] = params[:name]
            end

            desc 'Delete an user.'
            params do
                requires :email, type: String, desc: 'Email (used as unique id)'
            end
            delete ':email' do
                if not $sample_data.key?(params[:email])
                    error!({ error: 'User not found', detail: '' }, 404)
                end
                $sample_data.delete(params[:email])
            end
        end
    end
end
