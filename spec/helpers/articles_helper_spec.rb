require 'rails_helper'

RSpec.describe ArticlesHelper, type: :helper do
  describe "check sanitize must" do
    it "remove tags" do
      expect(helper.sanitize_content("<script></script>content<form></form>")).to eq("content")
    end

    %w[p pre code span blockquote strong ul li ol em u del].each do |tag|
      it "enable tag <#{tag}>" do
        text = "<#{tag}>content</#{tag}>"
        expect(helper.sanitize_content(text)).to eq(text)
      end
    end

    it "enable attribute class" do
      text = "<p class=\"strong\">content</p>"
      expect(helper.sanitize_content(text)).to eq(text)
    end

    it "remove other attributes" do
      text = "<p style=\"color:red\" required>content</p>"
      expect(helper.sanitize_content(text)).to eq('<p>content</p>')
    end
  end
end
