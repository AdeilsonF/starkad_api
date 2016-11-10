module Api
  module V1
    class ProductsController < ApiController
      respond_to :json
      # skip_before_action :auth_with_token!, only: [:show]

      def index
       products = Product.all
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
