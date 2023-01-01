require 'rails_helper'

RSpec.describe Machine, type: :model do
  describe 'validations' do
    it { should validate_presence_of :location }
    it { should belong_to :owner }
    it {should have_many :machine_snacks}
    it {should have_many(:snacks).through(:machine_snacks)}
  end

  describe "average_snack_price" do 
    it 'averages the price for all the snacks in this machine' do
      sam = Owner.create!(name: "Sam's Snacks")
      dons_drinks = sam.machines.create!(location: "Don's Mixed Drinks")

      cheetohs = Snack.create!(name: "Jalapeno Cheetohs", price: 3.50)
      powerade = Snack.create!(name: "Powerade Blue", price: 1.50)
      oreos = Snack.create!(name: "Oreos", price: 2.50)

      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: cheetohs.id)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: powerade.id)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: oreos.id)

      expect(dons_drinks.average_snack_price).to eq(2.50)
    end
  end
end

