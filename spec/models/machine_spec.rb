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

  describe "snack_count" do 
    it 'counts the number of distinct snacks' do
      sam = Owner.create!(name: "Sam's Snacks")
      
      dons_drinks = sam.machines.create!(location: "Don's Mixed Drinks")
      
      powerade = Snack.create!(name: "Powerade Blue", price: 1.00)
      oreos = Snack.create!(name: "Oreos", price: 0.75)
      cheetohs = Snack.create!(name: "Jalapeno Cheetohs", price: 2.50)

      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: powerade.id)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: oreos.id)
      MachineSnack.create!(machine_id: dons_drinks.id, snack_id: cheetohs.id)

      turing = sam.machines.create!(location: "Turing Basement")

      chips = Snack.create!(name: "Plain Ol Chips", price: 4.00)
      cheetohs = Snack.create!(name: "Jalapeno Cheetohs", price: 2.50)
      cheetohs = Snack.create!(name: "Jalapeno Cheetohs", price: 2.50)

      MachineSnack.create!(machine_id: turing.id, snack_id: chips.id)
      MachineSnack.create!(machine_id: turing.id, snack_id: cheetohs.id)

      mountain_view = sam.machines.create!(location: "Mountain View High School")

      expect(dons_drinks.snack_count).to eq(3)
      expect(turing.snack_count).to eq(2)
      expect(mountain_view.snack_count).to eq(0)
    end
  end
end

