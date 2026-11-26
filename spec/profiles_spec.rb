# frozen_string_literal: true

require "ladl"

RSpec.describe "the extracted label profiles" do
  Dir[File.join(__dir__, "..", "*.lml")].sort.each do |path|
    it "loads #{File.basename(path)}" do
      profile = Ladl.load_profile(path)
      expect(profile.style.name).to be_a(String)
      expect(profile.labeller_names).not_to be_empty
    end
  end

  # The host declares the label_context associations (MN 112: an
  # element carrying children to be labeled declares the context that
  # scopes them); labeled leaves declare their own context.
  it "labels a document tree with each profile" do
    tree = Ladl::ContentElement.new(id: "doc", type: "document",
      label_context: "DocumentContext", children: [
      Ladl::ContentElement.new(id: "c1", type: "clause",
        label_context: "ClauseContext", children: [
        Ladl::ContentElement.new(id: "c1s1", type: "subclause")]),
      Ladl::ContentElement.new(id: "a1", type: "annex",
        label_context: "AnnexContext"),
    ])
    Dir[File.join(__dir__, "..", "*.lml")].sort.each do |path|
      result = Ladl::Runtime::Engine.new(Ladl.load_profile(path)).label(tree)
      expect(result.labels_by_element_id["c1"]).to be_a(Ladl::Label)
      expect(result.labels_by_element_id["a1"].value).to match(/Annex|Appendix/)
    end
  end

  it "labels multilingually: the same profile renders French through the labels dictionary" do
    tree = Ladl::ContentElement.new(id: "doc", type: "document",
      label_context: "DocumentContext", children: [
      Ladl::ContentElement.new(id: "c1", type: "clause",
        label_context: "ClauseContext"),
      Ladl::ContentElement.new(id: "a1", type: "annex",
        label_context: "AnnexContext"),
    ])
    french = {
      "clause" => "Article", "annex" => "Annexe", "figure" => "Figure",
      "table" => "Tableau", "note" => "Note", "example" => "Exemple",
      "formula" => "Équation", "list" => "Liste", "section" => "Section",
      "appendix" => "Appendice", "subclause" => "Article",
    }
    Dir[File.join(__dir__, "..", "*.lml")].sort.each do |path|
      result = Ladl::Runtime::Engine.new(Ladl.load_profile(path), labels: french).label(tree)
      # bare-number schemes (IALA guideline, IETF locals) carry the word
      # only in the global cross-reference templates
      expect(result.labels_by_element_id["c1"].global_value).to match(/\A(Article|Section|Clause)\b/)
      expect(result.labels_by_element_id["a1"].value).to match(/\A(Annexe|Appendice|Annex|Appendix)/)
    end
  end
end
