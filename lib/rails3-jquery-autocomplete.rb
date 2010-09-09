module Rails3JQueryAutocomplete
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Inspired on DHH's autocomplete plugin
  # 
  # Usage:
  # 
  # class ProductsController < Admin::BaseController
  #   autocomplete :brand, :name
  # end
  #
  # This will magically generate an action autocomplete_brand_name, so, 
  # don't forget to add it on your routes file
  # 
  #   resources :products do
  #      get :autocomplete_brand_name, :on => :collection
  #   end
  #
  # Now, on your view, all you have to do is have a text field like:
  # 
  #   f.text_field :brand_name, :autocomplete => autocomplete_brand_name_products_path
  #
  #
  module ClassMethods
    def autocomplete(object, method, options = {})

      define_method("autocomplete_#{object}_#{method}") do
        unless params[:term] && params[:term].empty?
          items = Category.where("this.name.match(/#{params[:term]}/i)").limit(10).asc("#{method}")
        else
          items = {}
        end

        render :json => json_for_autocomplete(items, method)
      end
    end
  end

  private
  def json_for_autocomplete(items, method)
    items.collect {|i| {"id" => "#{i.id}", "label" => "#{i.name}", "value" => "#{i.name}"}}
  end
end

class ActionController::Base
  include Rails3JQueryAutocomplete
end