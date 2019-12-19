module ApplicationHelper
  def plural(count, value)
    # custom pluralization
    # for russian pluralization
    val = "plural.#{value}"
    count.to_s + ' ' + Russian.p(count, t("#{val}_1", locale: :ru), t("#{val}_2", locale: :ru), t("#{val}_10", locale: :ru))
  end

  def flash_class(level)
    case level
      when 'notice'  then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error'   then "alert alert-danger"
      when 'alert'   then "alert alert-danger"
    end
  end
end
