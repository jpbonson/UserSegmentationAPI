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
            route_param :email do
                get do
                    $sample_data[params[:email]]
                end
            end

            desc 'Create an user.'
            params do
                requires :email, type: String, desc: 'Email (used as unique id)'
                requires :name, type: String, desc: 'Name'
            end
            post do
                $sample_data[params[:email]] = params[:name]
            end

            desc 'Update an user.'
            params do
                requires :email, type: String, desc: 'Email (used as unique id)'
                requires :name, type: String, desc: 'Name'
            end
            put ':email' do
                $sample_data[params[:email]] = params[:name]
            end

            desc 'Delete an user.'
            params do
                requires :email, type: String, desc: 'Email (used as unique id)'
            end
            delete ':email' do
                $sample_data.delete(params[:email])
            end
        end
    end
end
