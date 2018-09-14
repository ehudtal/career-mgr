shared_examples_for "valid url" do |attribute, options={}|
  describe "validating #{attribute} format" do
    it "rejects invalid url" do
      object = described_class.new attribute => 'a b c'
    
      expect(object).to_not be_valid
      expect(object.errors[attribute]).to include('is an invalid URL')
    end
  
    if options[:allow_blank]
      it "allows blank urls" do
        object = described_class.new
        object.valid?
    
        expect(object.errors[attribute]).to_not include('is an invalid URL')
      end
    else
      it "rejects blank urls" do
        object = described_class.new
        object.valid?
    
        expect(object.errors[attribute]).to include('is an invalid URL')
      end
    end  
    
    it "sets the protocol if missing" do
      url = 'example.com'

      object = described_class.new attribute => url
      object.valid?

      expect(object.send(attribute)).to eq("http://#{url}")
    end
  end
end

shared_examples_for "unsubscribable" do
  def header name
    field = mail.header_fields.detect{|h| h.name == name}
    field ? field.value : nil
  end

  it { expect(header('List-Unsubscribe')).to match(%r!^<http://localhost:3011/fellow/profile/unsubscribe\?token=[0-9a-f]{16}>$!) }
end