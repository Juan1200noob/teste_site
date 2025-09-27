require 'sinatra'
require 'mail'
require 'dotenv/load'


get '/' do
  erb :index
end

post '/contact' do
    email = params[:email]
    message = params[:message]

    Mail.defaults do
        delivery_method :smtp, {
            address:              'smtp.gmail.com',
            port:                 587,
            user_name:            ENV['EMAIL_APP'],
            password:             ENV['PASSWORD_APP'],
            authentication:       'plain',
            enable_starttls_auto: true
        }
    end

    Mail.deliver do
        to email
        from ENV['EMAIL_APP']
        subject 'Novo contato'
        body message
    end

    erb :aviso, locals: { message: 'Mensagem enviada com sucesso!' }
end
