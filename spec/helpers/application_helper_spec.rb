require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "check plural for russian" do
    it "with count equal 1" do
      expect(helper.plural(1, 'article')).to eq("1 новость")
    end

    it "with count equal 2" do
      expect(helper.plural(2, 'article')).to eq("2 новости")
    end

    it "with count equal 10" do
      expect(helper.plural(10, 'article')).to eq("10 новостей")
    end
  end

  describe "check get flash class" do
    it "with error" do
      expect(helper.flash_class('error')).to eq("alert alert-danger")
    end

    it "with alert" do
      expect(helper.flash_class('alert')).to eq("alert alert-danger")
    end

    it "with success" do
      expect(helper.flash_class('success')).to eq("alert alert-success")
    end

    it "with notice" do
      expect(helper.flash_class('notice')).to eq("alert alert-info")
    end
  end
end
