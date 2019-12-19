require 'rails_helper'

RSpec.describe "articles/index", type: :view do
  before(:each) do
   @articles = create_list(:article, 2)
  end

  it "renders a list of articles" do
    render
    assert_select ".lead>a", :text => "Title".to_s, :count => 2
    assert_select ".card-body", :text => "MyText".to_s, :count => 2
  end
end
