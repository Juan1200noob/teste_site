require 'sinatra'
require 'mail'
require 'dotenv/load'

set :port, ENV['PORT'] || 4567

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

    begin
        Mail.deliver do
            to ENV['EMAIL_APP']
            from ENV['EMAIL_APP']
            subject 'Novo contato'
            body message
        end

        erb :aviso, locals: { message: 'Mensagem enviada com sucesso!' }
    rescue => e
        erb :aviso, locals: { message: "Erro ao enviar: #{e.message}" }
    end 

    puts "EMAIL_APP: #{ENV['EMAIL_APP']}"
    puts "PASSWORD_APP: #{ENV['PASSWORD_APP']}"

    erb :aviso, locals: { message: 'Mensagem enviada com sucesso!' }
end
