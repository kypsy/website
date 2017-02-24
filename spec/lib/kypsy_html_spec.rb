require 'spec_helper'

describe KypsyHTML do
  describe "@usernames" do
    it "turns @username into a link" do
      expect(Redcarpet::Markdown.new(KypsyHTML).render("@username")).to include "<p><a href='/@username'>@username</a>"
    end

    it "wraps text around it" do
      expect(Redcarpet::Markdown.new(KypsyHTML).render("Hi I am @username the user")).to include "Hi I am <a href='/@username'>@username</a> the user"
    end

    it "handles ., _, -, and numbers" do
      expect(Redcarpet::Markdown.new(KypsyHTML).render("@examp1e.boy_1-mccool")).to include "<a href='/@examp1e.boy_1-mccool'>@examp1e.boy_1-mccool</a>"
    end

    it "ignores a period" do
      expect(Redcarpet::Markdown.new(KypsyHTML).render("@examp1e.")).to include "<a href='/@examp1e'>@examp1e</a>."
    end

    it "ignores an email address" do
      expect(Redcarpet::Markdown.new(KypsyHTML).render("bob@examp1e.com")).to eq "<p>bob@examp1e.com</p>\n"
    end

  end

  describe "#searches" do
    it "turns #search into a search link" do
      expect(Redcarpet::Markdown.new(KypsyHTML).render("I am #cool")).to include "<a href='/people?search=cool'>#cool</a>"
    end

    it "turns #search into a search link with numbers underscores and dashes" do
      expect(Redcarpet::Markdown.new(KypsyHTML).render("I am #cool_123-guy")).to include "<a href='/people?search=cool_123-guy'>#cool_123-guy</a>"
    end

    it "only if it's a new word" do
      expect(Redcarpet::Markdown.new(KypsyHTML).render("I am #cool_123-guy")).to include "I am <a href='/people?search=cool_123-guy'>#cool_123-guy</a>"
    end

    it "starts with # is still an h1" do
      expect(Redcarpet::Markdown.new(KypsyHTML).render("#Notice I am #cool")).to include "<h1>Notice"
    end

    it "ignores a period" do
      expect(Redcarpet::Markdown.new(KypsyHTML).render("link #examp1e.")).to include "link <a href='/people?search=examp1e'>#examp1e</a>."
    end

  end
end
