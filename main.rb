require 'sinatra'
require 'grape'

module UserSegmentation
    class API < Grape::API
        version 'v1', using: :path
        format :json
        prefix :api

        resource :users do
            desc 'Return a sample for get.'
            get do
                { hello: 'world!!!' }
            end
        end
    end
end
