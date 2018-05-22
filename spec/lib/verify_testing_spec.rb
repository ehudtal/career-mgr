require 'rails_helper'
require 'verify_testing'

RSpec.describe VerifyTesting do
  describe "::verify" do
    it "is valid" do
      expect(subject.valid?).to be
    end
  end
end