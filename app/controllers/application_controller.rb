require './config/environment'

class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    register Sinatra::Flash

    configure do
        enable :sessions
        set :session_secret, "appdrinkstotal-4th"

        set :public_folder, 'public'
        set :views, 'app/views'
    end

    get "/" do
        if logged_in?
            redirect "/clients/#{current_client.id}"
        else
            erb :welcome
        end
    end

    get '/logout' do
        session.clear
        redirect'/'
    end

    helpers do
        def logged_in?
            !!current_client
        end

        def current_client
            @current_client ||= Client.find_by(id: session[:client_id]) if session[:client_id]
        end

        def authentication_required
            if !logged_in?
                flash[:notice] = "You must be logged in."
                redirect '/login'
            end
        end
    end

end
