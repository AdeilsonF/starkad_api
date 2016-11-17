module Api
  module V1
    class ProductsController < ApiController
      respond_to :json
      # skip_before_action :auth_with_token!, only: [:show]

      def index
       products = Product.search(params)
       render json: products
      end

      def create
        product = current_user.products.build(product_params)
        if product.save
          render json: product, status: 201, location: [:api, product]
        else
          render json: {errors: product.errors}, status: 422
        end
      end

      def show
        product = find_product
        render json: product
      end

      def update
        product = current_user.products.find(params[:id])
        if product.update(product_params)
          render json: product, status: 200, location: [:api, product]
        else
          render json: { errors: product.errors }, status: 422
        end
      end

      def destroy
        product = current_user.products.find(params[:id])
        product.destroy
        head 204
      end

      private
      def find_product
        Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:title,:price,:published)
      end
    end
  end
end
