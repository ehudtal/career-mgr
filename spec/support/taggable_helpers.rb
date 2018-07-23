RSpec.shared_examples "taggable" do |object_type, taggable_type|
  describe "#{taggable_type}_tags" do
    it "returns a semicolon-delimited list of associated #{taggable_type} names" do
      object = build object_type
      taggable_1 = build taggable_type, name: 'Taggable 1'
      taggable_2 = build taggable_type, name: 'Taggable 2'
  
      allow(object).to receive(taggable_type.to_s.pluralize.to_sym).and_return([taggable_1, taggable_2])
  
      expect(object.send(:"#{taggable_type}_tags")).to eq("Taggable 1;Taggable 2")
    end
  end

  describe "##{taggable_type}_tags=" do
    it "converts a semicolon-delimited list of industry names into associations" do
      object = create object_type
      taggable_1 =  create taggable_type, name: 'Taggable 1'
      taggable_2 =  create taggable_type, name: 'Taggable 2'
      taggable_3 =  create taggable_type, name: 'Taggable 3'
  
      object.send(:"#{taggable_type}_tags=", "Taggable 1;Taggable 2")
  
      taggables = object.send(taggable_type.to_s.pluralize.to_sym)
    
      expect(taggables).to include(taggable_1)
      expect(taggables).to include(taggable_2)
      expect(taggables).to_not include(taggable_3)
    end
  end
end