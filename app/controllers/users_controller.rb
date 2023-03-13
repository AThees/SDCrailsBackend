class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]

    # REGISTER
    def create
        testeUsername = User.find_by(username: params[:username])
        if params[:username] == ""
            render json: { error: "O nome de usuário não pode ser vazio" }
            return
        elsif params[:username] == testeUsername[:username]
            render json: { error: "Esse nome de usuário já está sendo utilizado" }
            return
        else
            @user = User.create(user_params)
            if @user.valid?
                @token = encode_token({ user_id: @user.id })
                render json: { user: @user, token: @token }
            else
                render json: { error: "Falha ao criar o usuário" }
            end
        end
    end

    # DELETE

    def destroy
        @user = User.find_by(id: params[:id])
        @user.destroy
        render json: { message: "Usuário deletado com sucesso" }
    end

    # LOGGING IN
    def login
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            token = encode_token({ user_id: @user.id })
            render json: { user: @user, token: token }
        else
            render json: { error: "Usuário ou senha inválidos" }
        end
    end

    def auto_login
        render json: @user
    end

    private

    def user_params
        params.permit(:username, :password, :name, :email)
    end

end
