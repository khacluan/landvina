module ApplicationHelper
  include ActionView::Helpers::JavaScriptHelper
  
  def load_data(model, opts = {})
    opts = {where: nil, includes: nil, per_page: 10 }.merge(opts)
    if opts[:where].nil? == false
      eval("@#{model.to_s.pluralize.downcase} = model.where(opts[:where]).order('created_at DESC').page(params[:page] || 1).per(opts[:per_page])")
    elsif opts[:includes].nil? == false
      eval("@#{model.to_s.pluralize.downcase} = model.includes(opts[:include]).order('created_at DESC').page(params[:page] || 1).per(opts[:per_page])")
    else
      eval("@#{model.to_s.pluralize.downcase} = model.order('created_at DESC').page(params[:page] || 1).per(opts[:per_page])")
    end
  end
  
  def load_response_from_iframe(container, response, successful=true, callback_js='')
      if request.xhr? == nil
        responds_to_parent do
          render js: %Q{
                          $('#{container}').html('#{escape_javascript(response)}');
                       }
        end
      end
  end
  
end
