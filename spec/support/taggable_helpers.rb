RSpec.shared_examples "taggable" do |object_type, taggable_type|
  describe "#{taggable_type}_tags" do
    it "returns a semicolon-delimited list of associated #{taggable_type} names" do
      object = create object_type
      expect(object).to be_valid
      taggable_1 = create taggable_type, name: 'Taggable 1'
      expect(taggable_1).to be_valid
      taggable_2 = create taggable_type, name: 'Taggable 2'
      expect(taggable_2).to be_valid
      
      object.send(:"#{taggable_type}_ids=", [taggable_1, taggable_2].map(&:id))
  
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

RSpec.shared_examples "taggable_combined" do |object_type, taggable_type_a, taggable_type_b|
  describe "##{taggable_type_a}_#{taggable_type_b}_tags" do
    it "returns a semicolon-delimited list of unique associated #{taggable_type_a} AND #{taggable_type_b} names" do
      object = create object_type
      
      taggable_a_1 = create taggable_type_a, name: 'Taggable A 1'
      taggable_a_2 = create taggable_type_a, name: 'Taggable Shared'
      taggable_b_1 = create taggable_type_b, name: 'Taggable B 1'
      taggable_b_2 = create taggable_type_b, name: 'Taggable Shared'
      
      taggables_a = taggable_type_a.to_s.pluralize.to_sym
      taggables_b = taggable_type_b.to_s.pluralize.to_sym

      object.send(:"#{taggable_type_a}_ids=", [taggable_a_1, taggable_a_2].map(&:id))
      object.send(:"#{taggable_type_b}_ids=", [taggable_b_1, taggable_b_2].map(&:id))
      
      list = object.send(:"#{taggable_type_a}_#{taggable_type_b}_tags").split(';')

      expect(list.size).to eq(3)
      expect(list).to include('Taggable A 1')
      expect(list).to include('Taggable B 1')
      expect(list).to include('Taggable Shared')
    end
  end

  describe "##{taggable_type_a}_#{taggable_type_b}_tags=" do
    it "converts a semicolon-delimited list of #{taggable_type_a}/#{taggable_type_b} names into associations" do
      object = create object_type

      taggable_a_1 =  create taggable_type_a, name: 'Taggable A 1'
      taggable_a_2 =  create taggable_type_a, name: 'Taggable Shared'
      taggable_a_3 =  create taggable_type_a, name: 'Other'

      taggable_b_1 =  create taggable_type_b, name: 'Taggable B 1'
      taggable_b_2 =  create taggable_type_b, name: 'Taggable Shared'
      taggable_b_3 =  create taggable_type_b, name: 'Other'
      
      object.send(:"#{taggable_type_a}_#{taggable_type_b}_tags=", "Taggable A 1;Taggable B 1;Taggable Shared")
      
      taggables_a = object.send(taggable_type_a.to_s.pluralize.to_sym)
      taggables_b = object.send(taggable_type_b.to_s.pluralize.to_sym)
      
      expect(taggables_a).to include(taggable_a_1)
      expect(taggables_a).to include(taggable_a_2)
      expect(taggables_a).to_not include(taggable_a_3)
      
      expect(taggables_b).to include(taggable_b_1)
      expect(taggables_b).to include(taggable_b_2)
      expect(taggables_b).to_not include(taggable_b_3)
    end
  end
end