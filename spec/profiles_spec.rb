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

  it "labels a document tree with each profile" do
    tree = Ladl::ContentElement.new(id: "doc", type: "document", children: [
      Ladl::ContentElement.new(id: "c1", type: "clause",
        children: [Ladl::ContentElement.new(id: "c1s1", type: "subclause")]),
      Ladl::ContentElement.new(id: "a1", type: "annex"),
    ])
    Dir[File.join(__dir__, "..", "*.lml")].sort.each do |path|
      result = Ladl::Runtime::Engine.new(Ladl.load_profile(path)).label(tree)
      expect(result.labels_by_element_id["c1"]).to be_a(Ladl::Label)
      expect(result.labels_by_element_id["a1"].value).to match(/Annex|Appendix/)
    end
  end
end
