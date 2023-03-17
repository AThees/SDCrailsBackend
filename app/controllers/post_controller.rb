class PostController < ApplicationController
    # MÉTODO PARA ENVIAR A URL DE UMA IMAGEM
    # url_for(@[POST].image)

    def create
        begin
            post_params = params.permit(:title, :body, :image);
            post = Post.new(post_params);
            post.user_id = get_user_id();
            post.image.attach(params[:image]);
            post.save;
            render json: {code: 0, message: "Post criado com sucesso"}
        rescue => exception
            render json: {code: 1, message: "Erro ao criar post", error: exception}
        end
    end

    def index
        post = Post.find(params[:id])
        render json: {post: post, image: url_for(post.image)}
    end

    def destroy
        post = Post.find(params[:id])
        token = auth_header.split(" ")[1]
        decoded_token = JWT.decode(token, "my_s3cr3t", true, algorithm: "HS256")
        requestor_user_id = decoded_token[0]["user_id"]
        if is_owner?(post, requestor_user_id)
            post.destroy
            render json: {code: 0, message: "Post deletado com sucesso"}
        else
            render json: {code: 1, message: "Você não pode deletar esse post"}
        end
    end

    def is_owner?(post, user_id)
        if post.user_id == user_id.to_s
            return true
        else
            return false
        end
    end

    def get_user_id()
        token = auth_header.split(" ")[1]
        decoded_token = JWT.decode(token, "my_s3cr3t", true, algorithm: "HS256")
        return decoded_token[0]["user_id"]
    end
end
